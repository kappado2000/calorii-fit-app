"""Generates the Calorii Fit app icon: an apple silhouette (food/health)
crossed by a heartbeat pulse line (fitness) on a green brand gradient.
Renders at 4x supersample then downsamples for clean anti-aliased edges.
Produces:
  - app_icon.png            (full icon w/ background, for iOS + legacy Android)
  - app_icon_foreground.png (transparent glyph only, for Android adaptive icon)
  - app_icon_background.png (gradient only, for Android adaptive icon)
"""

from PIL import Image, ImageDraw, ImageFilter
import math

SCALE = 4
SIZE = 1024 * SCALE

BRAND_TOP = (34, 176, 122)      # lighter green, top-left
BRAND_BOTTOM = (13, 110, 74)    # deeper green, bottom-right
APPLE_COLOR = (255, 255, 255)
LEAF_COLOR = (255, 255, 255)
PULSE_COLOR = (255, 158, 66)    # warm amber accent


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


def apple_path(cx, cy, s):
    """Closed bezier apple silhouette, unit box ~ (-1..1) scaled by s, centered
    at (cx,cy). Slightly asymmetric (right lobe a touch bigger) for a more
    organic, hand-crafted feel than a perfectly symmetric blob."""
    def pt(x, y):
        return (cx + x * s, cy + y * s)

    p_bottom = pt(0.02, 0.66)
    p_left_low_c1 = pt(-0.50, 0.64)
    p_left_low_c2 = pt(-0.64, 0.36)
    p_left_mid = pt(-0.60, 0.02)

    p_left_mid_c1 = pt(-0.57, -0.26)
    p_left_mid_c2 = pt(-0.44, -0.42)
    p_left_top = pt(-0.26, -0.49)

    p_left_top_c1 = pt(-0.15, -0.53)
    p_left_top_c2 = pt(-0.09, -0.49)
    p_top_dip = pt(0.0, -0.45)

    p_top_dip_c1 = pt(0.09, -0.49)
    p_top_dip_c2 = pt(0.15, -0.53)
    p_right_top = pt(0.26, -0.49)

    p_right_top_c1 = pt(0.47, -0.43)
    p_right_top_c2 = pt(0.65, -0.22)
    p_right_mid = pt(0.63, 0.06)

    p_right_mid_c1 = pt(0.66, 0.34)
    p_right_mid_c2 = pt(0.52, 0.64)
    p_bottom2 = p_bottom

    steps = 60
    path = [p_bottom]
    path += cubic_bezier(p_bottom, p_left_low_c1, p_left_low_c2, p_left_mid, steps)
    path += cubic_bezier(p_left_mid, p_left_mid_c1, p_left_mid_c2, p_left_top, steps)
    path += cubic_bezier(p_left_top, p_left_top_c1, p_left_top_c2, p_top_dip, steps)
    path += cubic_bezier(p_top_dip, p_top_dip_c1, p_top_dip_c2, p_right_top, steps)
    path += cubic_bezier(p_right_top, p_right_top_c1, p_right_top_c2, p_right_mid, steps)
    path += cubic_bezier(p_right_mid, p_right_mid_c1, p_right_mid_c2, p_bottom2, steps)
    return path


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

    cx, cy = SIZE / 2, SIZE / 2 + SIZE * 0.03
    apple_scale = SIZE * 0.34

    mask = Image.new("L", (SIZE, SIZE), 0)
    md = ImageDraw.Draw(mask)
    md.polygon(apple_path(cx, cy, apple_scale), fill=255)

    apple_layer = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    ad = ImageDraw.Draw(apple_layer)
    ad.polygon(apple_path(cx, cy, apple_scale), fill=APPLE_COLOR + (255,))

    for target in (full, fg):
        target.alpha_composite(apple_layer)

    # Stem — short, sitting cleanly above the body's dimple, not buried in it.
    stem_bottom = (cx, cy - apple_scale * 0.44)
    stem_top = (cx + apple_scale * 0.03, cy - apple_scale * 0.64)
    stem_layer = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    sd = ImageDraw.Draw(stem_layer)
    sd.line([stem_bottom, stem_top], fill=APPLE_COLOR + (255,), width=int(SIZE * 0.012))
    for target in (full, fg):
        target.alpha_composite(stem_layer)

    # Leaf, sprouting from the stem top, angled up and to the right — clearly
    # separated from the body so it doesn't crowd the dimple. Same white as
    # the apple body — a deliberately two-tone (white + amber) glyph so it
    # stays crisp and legible even scaled down to a small app-switcher size.
    leaf_layer = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    ld = ImageDraw.Draw(leaf_layer)
    leaf_pts = leaf_path(stem_top[0], stem_top[1] + apple_scale * 0.02, apple_scale * 0.5, flip=1)
    ld.polygon(leaf_pts, fill=LEAF_COLOR + (255,))
    for target in (full, fg):
        target.alpha_composite(leaf_layer)

    # Heartbeat pulse line across the apple's middle, clipped to the apple silhouette.
    pulse_layer = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    pd = ImageDraw.Draw(pulse_layer)
    draw_pulse_line(
        pd,
        cx,
        cy + apple_scale * 0.20,
        apple_scale * 1.2,
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

    print("done")


if __name__ == "__main__":
    build()
