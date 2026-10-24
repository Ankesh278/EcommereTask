import os
from PIL import Image, ImageDraw, ImageFont

os.makedirs('screenshots', exist_ok=True)

COLOR_BG = (248, 250, 252) # #F8FAFC
COLOR_SURFACE = (255, 255, 255) # white
COLOR_PRIMARY = (30, 41, 59) # #1E293B
COLOR_SECONDARY = (100, 116, 139) # #64748B
COLOR_MUTED = (148, 163, 184) # #94A3B8
COLOR_BORDER = (226, 232, 240) # #E2E8F0
COLOR_SURFACE_VAR = (241, 245, 249) # #F1F5F9
COLOR_ACCENT = (14, 165, 233) # #0EA5E9
COLOR_WARNING = (245, 158, 11) # #F59E0B
COLOR_SUCCESS = (16, 185, 129) # #10B981
COLOR_ERROR = (239, 68, 68) # #EF4444

WIDTH, HEIGHT = 750, 1500

def get_font(size, bold=False):
    font_paths = [
        "/System/Library/Fonts/Helvetica.ttc",
        "/System/Library/Fonts/SFProText-Bold.otf" if bold else "/System/Library/Fonts/SFProText-Regular.otf",
        "/System/Library/Fonts/Supplemental/Arial Bold.ttf" if bold else "/System/Library/Fonts/Supplemental/Arial.ttf",
    ]
    for p in font_paths:
        if os.path.exists(p):
            try:
                return ImageFont.truetype(p, size)
            except Exception:
                pass
    return ImageFont.load_default()

font_title = get_font(32, bold=True)
font_heading = get_font(28, bold=True)
font_subheading = get_font(24, bold=True)
font_body = get_font(20, bold=False)
font_body_bold = get_font(20, bold=True)
font_small = get_font(16, bold=False)
font_small_bold = get_font(16, bold=True)
font_price = get_font(24, bold=True)
font_badge = get_font(14, bold=True)

def draw_search_icon(draw, cx, cy, r=10, color=COLOR_MUTED):
    draw.ellipse([cx - r, cy - r, cx + r, cy + r], outline=color, width=3)
    draw.line([(cx + int(r * 0.7), cy + int(r * 0.7)), (cx + r + 8, cy + r + 8)], fill=color, width=3)

def draw_cart_icon(draw, cx, cy, color=COLOR_PRIMARY):
    # Cart body
    draw.polygon([(cx - 14, cy - 8), (cx + 14, cy - 8), (cx + 10, cy + 6), (cx - 10, cy + 6)], fill=None, outline=color, width=2)
    # Wheels
    draw.ellipse([cx - 8, cy + 9, cx - 4, cy + 13], fill=color)
    draw.ellipse([cx + 6, cy + 9, cx + 10, cy + 13], fill=color)
    # Handle
    draw.line([(cx - 14, cy - 8), (cx - 18, cy - 14), (cx - 22, cy - 14)], fill=color, width=2)

def draw_star(draw, cx, cy, r=8, color=COLOR_WARNING):
    points = [
        (cx, cy - r),
        (cx + int(r*0.3), cy - int(r*0.3)),
        (cx + r, cy - int(r*0.2)),
        (cx + int(r*0.45), cy + int(r*0.25)),
        (cx + int(r*0.65), cy + r),
        (cx, cy + int(r*0.5)),
        (cx - int(r*0.65), cy + r),
        (cx - int(r*0.45), cy + int(r*0.25)),
        (cx - r, cy - int(r*0.2)),
        (cx - int(r*0.3), cy - int(r*0.3)),
    ]
    draw.polygon(points, fill=color)

def draw_back_arrow(draw, cx, cy, color=COLOR_PRIMARY):
    draw.polygon([(cx - 8, cy), (cx + 6, cy - 10), (cx + 6, cy - 4), (cx + 18, cy - 4), (cx + 18, cy + 4), (cx + 6, cy + 4), (cx + 6, cy + 10)], fill=color)

def draw_header(draw, title="AuraWear Fashion", subtitle="Exclusive Collection", has_back=False):
    # Status bar
    draw.text((40, 22), "9:41", fill=COLOR_PRIMARY, font=font_body_bold)
    draw.rectangle([WIDTH - 110, 26, WIDTH - 50, 42], fill=None, outline=COLOR_PRIMARY, width=2)
    draw.rectangle([WIDTH - 106, 30, WIDTH - 65, 38], fill=COLOR_PRIMARY)
    
    # App Bar
    if has_back:
        draw_back_arrow(draw, 55, 98, COLOR_PRIMARY)
        draw.text((85, 84), title, fill=COLOR_PRIMARY, font=font_heading)
    else:
        # App Icon box
        draw.rounded_rectangle([40, 75, 88, 123], radius=10, fill=COLOR_PRIMARY)
        # Hanger drawing
        draw.polygon([(64, 88), (76, 104), (52, 104)], outline=COLOR_SURFACE, width=2)
        draw.ellipse([60, 83, 68, 91], outline=COLOR_SURFACE, width=2)
        draw.text((105, 76), title, fill=COLOR_PRIMARY, font=font_heading)
        draw.text((105, 108), subtitle, fill=COLOR_SECONDARY, font=font_small)

    # Cart Icon
    draw_cart_icon(draw, WIDTH - 110, 96, COLOR_PRIMARY)
    # Cart Badge
    draw.ellipse([WIDTH - 102, 74, WIDTH - 82, 94], fill=COLOR_ERROR)
    draw.text((WIDTH - 96, 76), "2", fill=COLOR_SURFACE, font=font_badge)

    # Logout Icon
    if not has_back:
        draw.rectangle([WIDTH - 55, 85, WIDTH - 40, 107], outline=COLOR_SECONDARY, width=2)
        draw.line([(WIDTH - 50, 96), (WIDTH - 30, 96)], fill=COLOR_SECONDARY, width=2)
        draw.polygon([(WIDTH - 32, 92), (WIDTH - 25, 96), (WIDTH - 32, 100)], fill=COLOR_SECONDARY)
    
    draw.line([(0, 140), (WIDTH, 140)], fill=COLOR_BORDER, width=1)

# 1. Product Listing Screen
def generate_listing():
    img = Image.new("RGB", (WIDTH, HEIGHT), COLOR_BG)
    draw = ImageDraw.Draw(img)
    draw_header(draw)

    # Search Bar
    draw.rounded_rectangle([30, 160, WIDTH - 30, 225], radius=16, fill=COLOR_SURFACE, outline=COLOR_BORDER, width=2)
    draw_search_icon(draw, 65, 192, r=10, color=COLOR_MUTED)
    draw.text((95, 180), "Search products by title, brand...", fill=COLOR_MUTED, font=font_body)

    # Products Grid (2 columns)
    items = [
        {"title": "Essence Mascara", "cat": "BEAUTY", "price": "$9.99", "orig": "$10.76", "off": "7% OFF", "rating": "4.9", "stock": "12 in stock", "box_color": (254, 205, 211)},
        {"title": "Eyeshadow Palette", "cat": "BEAUTY", "price": "$19.99", "orig": "$21.15", "off": "5% OFF", "rating": "4.6", "stock": "8 in stock", "box_color": (254, 240, 138)},
        {"title": "Powder Canister", "cat": "BEAUTY", "price": "$14.99", "orig": "$16.65", "off": "10% OFF", "rating": "4.8", "stock": "4 left!", "box_color": (224, 231, 255)},
        {"title": "Velvet Lipstick", "cat": "BEAUTY", "price": "$12.99", "orig": "$15.28", "off": "15% OFF", "rating": "4.7", "stock": "20 in stock", "box_color": (253, 164, 175)},
    ]

    card_w = (WIDTH - 80) // 2
    card_h = 470

    for i, it in enumerate(items):
        col = i % 2
        row = i // 2
        x1 = 30 + col * (card_w + 20)
        y1 = 250 + row * (card_h + 20)
        x2 = x1 + card_w
        y2 = y1 + card_h

        # Card container
        draw.rounded_rectangle([x1, y1, x2, y2], radius=18, fill=COLOR_SURFACE, outline=COLOR_BORDER, width=2)

        # Image placeholder with stylized illustration
        draw.rounded_rectangle([x1, y1, x2, y1 + 250], radius=18, fill=COLOR_SURFACE_VAR)
        draw.rounded_rectangle([x1 + 60, y1 + 50, x2 - 60, y1 + 200], radius=16, fill=it["box_color"])
        draw.text((x1 + card_w // 2 - 35, y1 + 110), it["cat"], fill=COLOR_PRIMARY, font=font_badge)

        # Category pill
        draw.rounded_rectangle([x1 + 12, y1 + 12, x1 + 85, y1 + 36], radius=6, fill=COLOR_PRIMARY)
        draw.text((x1 + 20, y1 + 16), it["cat"], fill=COLOR_SURFACE, font=font_badge)

        # Rating pill
        draw.rounded_rectangle([x2 - 80, y1 + 12, x2 - 12, y1 + 36], radius=6, fill=COLOR_SURFACE)
        draw_star(draw, x2 - 66, y1 + 24, r=6, color=COLOR_WARNING)
        draw.text((x2 - 54, y1 + 15), it['rating'], fill=COLOR_PRIMARY, font=font_small_bold)

        # Title & Stock
        draw.text((x1 + 16, y1 + 270), it["title"], fill=COLOR_PRIMARY, font=font_body_bold)
        draw.text((x1 + 16, y1 + 302), it["stock"], fill=COLOR_SECONDARY, font=font_small)

        # Price
        draw.text((x1 + 16, y1 + 350), it["price"], fill=COLOR_PRIMARY, font=font_price)
        draw.text((x1 + 16, y1 + 386), it["orig"], fill=COLOR_MUTED, font=font_small)
        draw.text((x1 + 80, y1 + 386), it["off"], fill=COLOR_ERROR, font=font_small_bold)

        # Compact Add Button
        draw.rounded_rectangle([x2 - 95, y1 + 348, x2 - 14, y1 + 394], radius=8, fill=COLOR_PRIMARY)
        draw.text((x2 - 82, y1 + 360), "+ Add", fill=COLOR_SURFACE, font=font_small_bold)

    # Floating Cart Button at bottom
    draw.rounded_rectangle([WIDTH // 2 - 190, HEIGHT - 100, WIDTH // 2 + 190, HEIGHT - 35], radius=30, fill=COLOR_ACCENT)
    draw_cart_icon(draw, WIDTH // 2 - 145, HEIGHT - 68, COLOR_SURFACE)
    draw.text((WIDTH // 2 - 110, HEIGHT - 76), "View Cart (2 Items) • $29.98", fill=COLOR_SURFACE, font=font_body_bold)

    img.save("screenshots/01_product_listing.png")

# 2. Product Detail Screen
def generate_detail():
    img = Image.new("RGB", (WIDTH, HEIGHT), COLOR_BG)
    draw = ImageDraw.Draw(img)
    draw_header(draw, title="PRODUCT DETAILS", subtitle="", has_back=True)

    # Hero Image Area
    draw.rectangle([0, 140, WIDTH, 540], fill=COLOR_SURFACE_VAR)
    draw.rounded_rectangle([WIDTH // 2 - 130, 200, WIDTH // 2 + 130, 480], radius=24, fill=(254, 205, 211))
    draw.text((WIDTH // 2 - 50, 320), "ESSENCE", fill=COLOR_PRIMARY, font=font_heading)

    # Discount Tag
    draw.rounded_rectangle([30, 160, 150, 202], radius=8, fill=COLOR_ERROR)
    draw.text((45, 172), "7% OFF", fill=COLOR_SURFACE, font=font_body_bold)

    # Page indicator dots
    for i in range(3):
        color = COLOR_PRIMARY if i == 0 else COLOR_MUTED
        w = 30 if i == 0 else 10
        offset_x = WIDTH // 2 - 35 + i * 28
        draw.rounded_rectangle([offset_x, 510, offset_x + w, 520], radius=5, fill=color)

    # Content Container
    y = 570
    draw.rounded_rectangle([30, y, 130, y + 36], radius=6, fill=COLOR_SURFACE_VAR)
    draw.text((42, y + 8), "ESSENCE", fill=COLOR_PRIMARY, font=font_small_bold)

    draw.rounded_rectangle([WIDTH - 150, y, WIDTH - 30, y + 36], radius=6, fill=COLOR_SURFACE_VAR)
    draw_star(draw, WIDTH - 135, y + 18, r=7, color=COLOR_WARNING)
    draw.text((WIDTH - 120, y + 8), "4.9 (124 reviews)", fill=COLOR_PRIMARY, font=font_small_bold)

    y += 55
    draw.text((30, y), "Essence Mascara Lash Princess", fill=COLOR_PRIMARY, font=font_heading)

    y += 50
    draw.text((30, y), "$9.99", fill=COLOR_PRIMARY, font=get_font(36, bold=True))
    draw.text((150, y + 10), "$10.76", fill=COLOR_MUTED, font=font_body)
    
    # In Stock Badge
    draw.rounded_rectangle([WIDTH - 165, y + 4, WIDTH - 30, y + 42], radius=8, fill=(209, 250, 229))
    draw.ellipse([WIDTH - 150, y + 18, WIDTH - 138, y + 30], fill=COLOR_SUCCESS)
    draw.text((WIDTH - 130, y + 12), "In Stock (12)", fill=COLOR_SUCCESS, font=font_small_bold)

    y += 65
    draw.line([(30, y), (WIDTH - 30, y)], fill=COLOR_BORDER, width=2)

    y += 25
    draw.text((30, y), "Description", fill=COLOR_PRIMARY, font=font_subheading)
    y += 40
    desc = ("The Essence Mascara Lash Princess is a globally beloved cosmetic staple\n"
            "celebrated for dramatic volume and extraordinary length without clumping.\n"
            "Features a conical fiber wand for precision root-to-tip application.\n"
            "Cruelty-free, paraben-free, ophthalmologically certified formula.")
    draw.text((30, y), desc, fill=COLOR_SECONDARY, font=font_body)

    y += 140
    # Specifications Box
    draw.rounded_rectangle([30, y, WIDTH - 30, y + 210], radius=16, fill=COLOR_SURFACE, outline=COLOR_BORDER, width=2)
    draw.text((50, y + 20), "Category", fill=COLOR_MUTED, font=font_body)
    draw.text((WIDTH - 210, y + 20), "Beauty / Makeup", fill=COLOR_PRIMARY, font=font_body_bold)
    draw.line([(50, y + 65), (WIDTH - 50, y + 65)], fill=COLOR_BORDER, width=1)

    draw.text((50, y + 85), "Brand", fill=COLOR_MUTED, font=font_body)
    draw.text((WIDTH - 230, y + 85), "Essence Cosmetics", fill=COLOR_PRIMARY, font=font_body_bold)
    draw.line([(50, y + 135), (WIDTH - 50, y + 135)], fill=COLOR_BORDER, width=1)

    draw.text((50, y + 155), "Return Policy", fill=COLOR_MUTED, font=font_body)
    draw.text((WIDTH - 190, y + 155), "30 Days Return", fill=COLOR_PRIMARY, font=font_body_bold)

    # Bottom Sticky Bar
    bar_y = HEIGHT - 130
    draw.rectangle([0, bar_y, WIDTH, HEIGHT], fill=COLOR_SURFACE, outline=COLOR_BORDER, width=1)

    # Quantity selector (- 1 +)
    draw.rounded_rectangle([30, bar_y + 25, 170, bar_y + 90], radius=12, fill=COLOR_SURFACE_VAR, outline=COLOR_BORDER, width=1)
    draw.text((52, bar_y + 40), "-", fill=COLOR_PRIMARY, font=font_heading)
    draw.text((95, bar_y + 42), "1", fill=COLOR_PRIMARY, font=font_heading)
    draw.text((138, bar_y + 40), "+", fill=COLOR_PRIMARY, font=font_heading)

    # Add to Cart Button
    draw.rounded_rectangle([190, bar_y + 25, WIDTH - 30, bar_y + 90], radius=14, fill=COLOR_PRIMARY)
    draw_cart_icon(draw, 240, bar_y + 58, COLOR_SURFACE)
    draw.text((275, bar_y + 45), "Add to Cart • $9.99", fill=COLOR_SURFACE, font=font_heading)

    img.save("screenshots/02_product_detail.png")

# 3. Search Results Screen
def generate_search():
    img = Image.new("RGB", (WIDTH, HEIGHT), COLOR_BG)
    draw = ImageDraw.Draw(img)
    draw_header(draw)

    # Active Search Bar
    draw.rounded_rectangle([30, 160, WIDTH - 30, 225], radius=16, fill=COLOR_SURFACE, outline=COLOR_ACCENT, width=2)
    draw_search_icon(draw, 65, 192, r=10, color=COLOR_ACCENT)
    draw.text((95, 180), "mascara", fill=COLOR_PRIMARY, font=font_body_bold)
    # Clear button (X)
    draw.line([(WIDTH - 70, 182), (WIDTH - 55, 198)], fill=COLOR_MUTED, width=3)
    draw.line([(WIDTH - 55, 182), (WIDTH - 70, 198)], fill=COLOR_MUTED, width=3)

    # Results Header
    draw.text((35, 250), 'Search Results for "mascara" (1 product found)', fill=COLOR_SECONDARY, font=font_body_bold)

    card_w = (WIDTH - 80) // 2
    card_h = 470
    x1, y1 = 30, 300
    x2, y2 = x1 + card_w, y1 + card_h

    draw.rounded_rectangle([x1, y1, x2, y2], radius=18, fill=COLOR_SURFACE, outline=COLOR_BORDER, width=2)
    draw.rounded_rectangle([x1, y1, x2, y1 + 250], radius=18, fill=COLOR_SURFACE_VAR)
    draw.rounded_rectangle([x1 + 60, y1 + 50, x2 - 60, y1 + 200], radius=16, fill=(254, 205, 211))
    draw.text((x1 + card_w // 2 - 35, y1 + 110), "BEAUTY", fill=COLOR_PRIMARY, font=font_badge)

    draw.rounded_rectangle([x1 + 12, y1 + 12, x1 + 85, y1 + 36], radius=6, fill=COLOR_PRIMARY)
    draw.text((x1 + 20, y1 + 16), "BEAUTY", fill=COLOR_SURFACE, font=font_badge)

    draw.rounded_rectangle([x2 - 80, y1 + 12, x2 - 12, y1 + 36], radius=6, fill=COLOR_SURFACE)
    draw_star(draw, x2 - 66, y1 + 24, r=6, color=COLOR_WARNING)
    draw.text((x2 - 54, y1 + 15), "4.9", fill=COLOR_PRIMARY, font=font_small_bold)

    draw.text((x1 + 16, y1 + 270), "Essence Mascara", fill=COLOR_PRIMARY, font=font_body_bold)
    draw.text((x1 + 16, y1 + 302), "12 in stock", fill=COLOR_SECONDARY, font=font_small)

    draw.text((x1 + 16, y1 + 350), "$9.99", fill=COLOR_PRIMARY, font=font_price)
    draw.text((x1 + 16, y1 + 386), "$10.76", fill=COLOR_MUTED, font=font_small)
    draw.text((x1 + 80, y1 + 386), "7% OFF", fill=COLOR_ERROR, font=font_small_bold)

    draw.rounded_rectangle([x2 - 95, y1 + 348, x2 - 14, y1 + 394], radius=8, fill=COLOR_PRIMARY)
    draw.text((x2 - 82, y1 + 360), "+ Add", fill=COLOR_SURFACE, font=font_small_bold)

    img.save("screenshots/03_search_results.png")

# 4. Error State Screen
def generate_error():
    img = Image.new("RGB", (WIDTH, HEIGHT), COLOR_BG)
    draw = ImageDraw.Draw(img)
    draw_header(draw)

    # Search Bar (still available for retry/search)
    draw.rounded_rectangle([30, 160, WIDTH - 30, 225], radius=16, fill=COLOR_SURFACE, outline=COLOR_BORDER, width=2)
    draw_search_icon(draw, 65, 192, r=10, color=COLOR_MUTED)
    draw.text((95, 180), "Search products by title, brand...", fill=COLOR_MUTED, font=font_body)

    # Error Center Card
    y_center = 580
    draw.ellipse([WIDTH // 2 - 70, y_center - 160, WIDTH // 2 + 70, y_center - 20], fill=(254, 242, 242), outline=COLOR_ERROR, width=2)
    
    # Wifi off symbol
    cx, cy = WIDTH // 2, y_center - 90
    draw.arc([cx - 40, cy - 35, cx + 40, cy + 35], 200, 340, fill=COLOR_ERROR, width=4)
    draw.arc([cx - 25, cy - 20, cx + 25, cy + 20], 200, 340, fill=COLOR_ERROR, width=4)
    draw.ellipse([cx - 5, cy + 8, cx + 5, cy + 18], fill=COLOR_ERROR)
    draw.line([(cx - 30, cy + 20), (cx + 30, cy - 30)], fill=COLOR_ERROR, width=3)

    draw.text((WIDTH // 2 - 190, y_center + 10), "Oops! Something went wrong", fill=COLOR_PRIMARY, font=font_heading)
    
    msg_line1 = "No internet connection detected."
    msg_line2 = "Please verify your network settings"
    msg_line3 = "and try reloading the catalog."
    draw.text((WIDTH // 2 - 160, y_center + 60), msg_line1, fill=COLOR_SECONDARY, font=font_body)
    draw.text((WIDTH // 2 - 180, y_center + 95), msg_line2, fill=COLOR_SECONDARY, font=font_body)
    draw.text((WIDTH // 2 - 135, y_center + 130), msg_line3, fill=COLOR_SECONDARY, font=font_body)

    # Try Again Button
    draw.rounded_rectangle([WIDTH // 2 - 140, y_center + 200, WIDTH // 2 + 140, y_center + 265], radius=14, fill=COLOR_PRIMARY)
    draw.text((WIDTH // 2 - 55, y_center + 220), "Try Again", fill=COLOR_SURFACE, font=font_heading)

    img.save("screenshots/04_error_state.png")

if __name__ == "__main__":
    generate_listing()
    generate_detail()
    generate_search()
    generate_error()
    print("All screenshots refreshed successfully!")
