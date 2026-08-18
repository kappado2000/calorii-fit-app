"""Generates the Calorii Fit app icon: a symmetric apple silhouette with a
bite (the classic, instantly-readable "apple" cue) crossed by a heartbeat
pulse line (fitness) on a green brand gradient. Renders at 4x supersample
then downsamples for clean anti-aliased edges.
Produces:
  - app_icon.png            (full icon w/ background, for iOS + legacy Android)
  - app_icon_foreground.png (transparent glyph only, for Android adaptive icon)
  - app_icon_background.png (gradient only, for Android adaptive icon)
"""

import numpy as np
from PIL import Image, ImageDraw, ImageFilter, ImageChops

SCALE = 4
SIZE = 1024 * SCALE

BRAND_TOP = (255, 232, 145)     # lighter golden yellow, top-left
BRAND_BOTTOM = (250, 190, 70)   # deeper amber, bottom-right
APPLE_COLOR = (47, 158, 79)
LEAF_COLOR = (47, 158, 79)
PULSE_COLOR = (255, 255, 255)   # white, for contrast against the green apple


def lerp(a, b, t):
    return a + (b - a) * t


def cubic_bezier(p0, p1, p2, p3, steps):
    pts = []
    for i in range(steps + 1):
        t = i / steps
        mt = 1 - t
        x = (mt ** 3) * p0[0] + 3 * (mt ** 2) * t * p1[0] + 3 * mt * (t ** 2) * p2[0] + (t ** 3) * p3[0]
        y = (mt ** 3) * p0[1] + 3 * (mt ** 2) * t * p1[1] + 3 * mt * (t ** 2) * p2[1] + (t ** 3) * p3[1]
        pts.append((x, y))
    return pts


def make_gradient(size, top_color, bottom_color):
    img = Image.new("RGB", (size, size))
    px = img.load()
    for y in range(size):
        for x in range(size):
            t = (x / size + y / size) / 2
            r = int(lerp(top_color[0], bottom_color[0], t))
            g = int(lerp(top_color[1], bottom_color[1], t))
            b = int(lerp(top_color[2], bottom_color[2], t))
            px[x, y] = (r, g, b)
    return img


def radial_gradient(size, cx, cy, radius, center_color, edge_color):
    """A radial gradient image, vectorized with numpy (a pure-Python
    per-pixel loop at 4096x4096 is too slow) — center_color at the
    gradient's origin, fading to edge_color at and beyond `radius`."""
    y, x = np.mgrid[0:size, 0:size]
    dist = np.sqrt((x - cx) ** 2 + (y - cy) ** 2)
    t = np.clip(dist / radius, 0.0, 1.0)
    channels = []
    for c_center, c_edge in zip(center_color, edge_color):
        channel = c_center + (c_edge - c_center) * t
        channels.append(channel.astype(np.uint8))
    arr = np.stack(channels, axis=-1)
    return Image.fromarray(arr, mode="RGB")


def apple_path(cx, cy, s):
    """Closed bezier apple silhouette, left/right symmetric, unit box scaled
    by s, centered at (cx,cy). Built as one right-side half (bottom -> top
    dip) then mirrored for the left half, so proportions match exactly on
    both sides — the bite (added separately) is what breaks the symmetry,
    same as the reference logo."""
    def pt(x, y):
        return (cx + x * s, cy + y * s)

    # Bottom dimple: a small blunted notch rather than a sharp point — real
    # apples have a slight indentation at the calyx (blossom) end, not a
    # needle tip.
    bottom_dip = (0.0, 0.685)
    bottom_dip_c1, bottom_dip_c2, bottom_bump = (0.045, 0.70), (0.085, 0.715), (0.115, 0.72)

    # Right-half anchor points, bump to top-center. Tapered (not a plain
    # circle/ball): the bottom pulls in sharply from the widest point,
    # which itself sits high (just above center) — the proportions that
    # actually read as "apple" rather than "sphere".
    right_low_c1, right_low_c2, right_mid = (0.24, 0.715), (0.56, 0.48), (0.62, 0.00)
    right_mid_c1, right_mid_c2, right_shoulder = (0.65, -0.26), (0.50, -0.43), (0.27, -0.49)
    right_shoulder_c1, right_shoulder_c2, top_dip = (0.15, -0.54), (0.07, -0.45), (0.0, -0.42)

    def mirror(p):
        return (-p[0], p[1])

    steps = 60
    minor_steps = 30
    right_side = []
    right_side += cubic_bezier(bottom_dip, bottom_dip_c1, bottom_dip_c2, bottom_bump, minor_steps)
    right_side += cubic_bezier(bottom_bump, right_low_c1, right_low_c2, right_mid, steps)
    right_side += cubic_bezier(right_mid, right_mid_c1, right_mid_c2, right_shoulder, steps)
    right_side += cubic_bezier(right_shoulder, right_shoulder_c1, right_shoulder_c2, top_dip, steps)

    left_side = []
    left_side += cubic_bezier(
        mirror(top_dip), mirror(right_shoulder_c2), mirror(right_shoulder_c1), mirror(right_shoulder), steps
    )
    left_side += cubic_bezier(mirror(right_shoulder), mirror(right_mid_c2), mirror(right_mid_c1), mirror(right_mid), steps)
    left_side += cubic_bezier(mirror(right_mid), mirror(right_low_c2), mirror(right_low_c1), mirror(bottom_bump), steps)
    left_side += cubic_bezier(
        mirror(bottom_bump), mirror(bottom_dip_c2), mirror(bottom_dip_c1), bottom_dip, minor_steps
    )

    path = [bottom_dip] + right_side + left_side
    return [pt(*p) for p in path]


def leaf_path(cx, cy, s, flip=1):
    """A small pointed leaf, unit box scaled by s, anchored at bottom point (cx,cy)."""
    def pt(x, y):
        return (cx + x * s * flip, cy + y * s)

    base = pt(0.0, 0.0)
    tip = pt(0.55, -0.62)
    c1 = pt(0.05, -0.12)
    c2 = pt(0.30, -0.55)
    c1b = pt(0.55, -0.30)
    c2b = pt(0.20, 0.02)

    steps = 50
    path = [base]
    path += cubic_bezier(base, c1, c2, tip, steps)
    path += cubic_bezier(tip, c1b, c2b, base, steps)
    return path


def draw_pulse_line(draw, cx, cy, w, thickness, color):
    """A classic single-blip heartbeat / EKG line: flat, small bump, one
    sharp tall spike, back to flat — the widely recognized "pulse" glyph."""
    half = w / 2
    pts = [
        (cx - half, cy),
        (cx - half * 0.42, cy),
        (cx - half * 0.24, cy - half * 0.16),
        (cx - half * 0.08, cy + half * 0.22),
        (cx + half * 0.06, cy - half * 0.62),
        (cx + half * 0.20, cy + half * 0.16),
        (cx + half * 0.36, cy),
        (cx + half, cy),
    ]
    draw.line(pts, fill=color, width=thickness, joint="curve")
    r = thickness * 0.5
    for p in pts:
        draw.ellipse([p[0] - r, p[1] - r, p[0] + r, p[1] + r], fill=color)


def build():
    bg = make_gradient(SIZE, BRAND_TOP, BRAND_BOTTOM)

    # Subtle soft radial highlight, top-left, for a touch of depth without
    # breaking the flat/modern look.
    highlight = Image.new("L", (SIZE, SIZE), 0)
    hd = ImageDraw.Draw(highlight)
    hd.ellipse(
        [SIZE * -0.35, SIZE * -0.35, SIZE * 0.75, SIZE * 0.75],
        fill=40,
    )
    highlight = highlight.filter(ImageFilter.GaussianBlur(SIZE * 0.08))
    white_layer = Image.new("RGB", (SIZE, SIZE), (255, 255, 255))
    bg = Image.composite(white_layer, bg, highlight)

    full = bg.convert("RGBA")
    fg = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))

    # The apple body sits a touch above dead-center so the stem+leaf above
    # it and the body below it balance out to a visually centered glyph
    # overall (verified against the rendered bounding box, not guessed).
    cx, cy = SIZE / 2, SIZE / 2 - SIZE * 0.02
    apple_scale = SIZE * 0.47

    apple_mask = Image.new("L", (SIZE, SIZE), 0)
    ImageDraw.Draw(apple_mask).polygon(apple_path(cx, cy, apple_scale), fill=255)

    # The bite: a circular notch on the upper-right side, at the shape's
    # widest point — the single feature that makes an apple silhouette
    # instantly read as "apple" rather than a generic round fruit.
    bite_cx = cx + apple_scale * 0.62
    bite_cy = cy - apple_scale * 0.05
    bite_r = apple_scale * 0.26
    bite_mask = Image.new("L", (SIZE, SIZE), 0)
    ImageDraw.Draw(bite_mask).ellipse(
        [bite_cx - bite_r, bite_cy - bite_r, bite_cx + bite_r, bite_cy + bite_r], fill=255
    )
    mask = ImageChops.subtract(apple_mask, bite_mask)

    # Dark green at the body's edges, fading in to the current green toward
    # the center — radius tuned to the shape's side-to-side reach, so the
    # top/sides fully reach the dark edge tone while the bottom tip (which
    # extends further) also lands fully dark, as an edge should.
    apple_edge_color = tuple(int(c * 0.45) for c in APPLE_COLOR)
    apple_fill = radial_gradient(SIZE, cx, cy, apple_scale * 0.55, APPLE_COLOR, apple_edge_color)

    apple_layer = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    apple_layer.paste(apple_fill, (0, 0), mask)
    for target in (full, fg):
        target.alpha_composite(apple_layer)

    # Stem — centered above the body's dimple.
    stem_bottom = (cx, cy - apple_scale * 0.40)
    stem_top = (cx + apple_scale * 0.02, cy - apple_scale * 0.60)
    stem_layer = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    sd = ImageDraw.Draw(stem_layer)
    sd.line([stem_bottom, stem_top], fill=APPLE_COLOR + (255,), width=int(SIZE * 0.012))
    for target in (full, fg):
        target.alpha_composite(stem_layer)

    # Leaf, sprouting from the stem top, angled up and to the right — the
    # bite (right side) balances its visual weight. Same white as the apple
    # body — a deliberately two-tone (white + amber) glyph so it stays
    # crisp and legible even scaled down to a small app-switcher size.
    leaf_layer = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    ld = ImageDraw.Draw(leaf_layer)
    leaf_pts = leaf_path(stem_top[0], stem_top[1] + apple_scale * 0.02, apple_scale * 0.48, flip=1)
    ld.polygon(leaf_pts, fill=LEAF_COLOR + (255,))
    for target in (full, fg):
        target.alpha_composite(leaf_layer)

    # Heartbeat pulse line across the apple's middle, clipped to the (bitten) silhouette.
    pulse_layer = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    pd = ImageDraw.Draw(pulse_layer)
    draw_pulse_line(
        pd,
        cx - apple_scale * 0.05,
        cy + apple_scale * 0.22,
        apple_scale * 1.1,
        int(SIZE * 0.019),
        PULSE_COLOR,
    )
    pulse_clipped = Image.composite(pulse_layer, Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0)), mask)
    for target in (full, fg):
        target.alpha_composite(pulse_clipped)

    out_size = 1024
    full_rgb = full.convert("RGB").resize((out_size, out_size), Image.LANCZOS)
    full_rgb.save("app_icon.png")

    fg_out = fg.resize((out_size, out_size), Image.LANCZOS)
    fg_out.save("app_icon_foreground.png")

    bg_out = bg.resize((out_size, out_size), Image.LANCZOS)
    bg_out.save("app_icon_background.png")

    bbox = fg_out.getbbox()
    w, h = fg_out.size
    print(f"glyph bbox center: x={((bbox[0]+bbox[2])/2/w):.3f} y={((bbox[1]+bbox[3])/2/h):.3f}")
    print("done")


if __name__ == "__main__":
    build()
