#!/bin/bash

input_file="$HOME/.config/omarchy/current/theme/alacritty.toml"
output_file="$HOME/.config/stremio-enhanced/themes/omarchy-dynamic.theme.css"

success() {
    echo -e "\e[32m[SUCCESS]\e[0m $1"
}

hex2rgb() {
    hex_input=$1
    r=$((16#${hex_input:0:2}))
    g=$((16#${hex_input:2:2}))
    b=$((16#${hex_input:4:2}))
    echo "$r, $g, $b"
}

extract_from_section() {
    local section="$1"
    local color_name="$2"
    awk -v section="[$section]" -v color="$color_name" '
        $0 == section { in_section=1; next }
        /^\[/ { in_section=0 }
        in_section && $1 == color {
            if (match($0, /(#|0x)([0-9a-fA-F]{6})/)) {
                hex_part = substr($0, RSTART + (substr($0, RSTART, 2) == "0x" ? 2 : 1), 6)
                print hex_part
                exit
            }
        }
    ' "$input_file"
}

# Extract colors from alacritty.toml
primary_foreground=$(extract_from_section "colors.primary" "foreground")
primary_background=$(extract_from_section "colors.primary" "background")
normal_black=$(extract_from_section "colors.normal" "black")
normal_red=$(extract_from_section "colors.normal" "red")
normal_green=$(extract_from_section "colors.normal" "green")
normal_yellow=$(extract_from_section "colors.normal" "yellow")
normal_blue=$(extract_from_section "colors.normal" "blue")
normal_magenta=$(extract_from_section "colors.normal" "magenta")
normal_cyan=$(extract_from_section "colors.normal" "cyan")
normal_white=$(extract_from_section "colors.normal" "white")
bright_black=$(extract_from_section "colors.bright" "black")
bright_red=$(extract_from_section "colors.bright" "red")
bright_green=$(extract_from_section "colors.bright" "green")
bright_yellow=$(extract_from_section "colors.bright" "yellow")
bright_blue=$(extract_from_section "colors.bright" "blue")
bright_magenta=$(extract_from_section "colors.bright" "magenta")
bright_cyan=$(extract_from_section "colors.bright" "cyan")
bright_white=$(extract_from_section "colors.bright" "white")

# Convert to RGB
rgb_primary_foreground=$(hex2rgb $primary_foreground)
rgb_primary_background=$(hex2rgb $primary_background)
rgb_normal_black=$(hex2rgb $normal_black)
rgb_normal_red=$(hex2rgb $normal_red)
rgb_normal_green=$(hex2rgb $normal_green)
rgb_normal_yellow=$(hex2rgb $normal_yellow)
rgb_normal_blue=$(hex2rgb $normal_blue)
rgb_normal_magenta=$(hex2rgb $normal_magenta)
rgb_normal_cyan=$(hex2rgb $normal_cyan)
rgb_normal_white=$(hex2rgb $normal_white)
rgb_bright_black=$(hex2rgb $bright_black)
rgb_bright_red=$(hex2rgb $bright_red)
rgb_bright_green=$(hex2rgb $bright_green)
rgb_bright_yellow=$(hex2rgb $bright_yellow)
rgb_bright_blue=$(hex2rgb $bright_blue)
rgb_bright_magenta=$(hex2rgb $bright_magenta)
rgb_bright_cyan=$(hex2rgb $bright_cyan)
rgb_bright_white=$(hex2rgb $bright_white)

create_dynamic_theme() {
    cat > "$output_file" << EOF
/**
 * @name Omarchy Dynamic Theme
 * @description Dynamically generated theme based on current omarchy colors
 * @version 1.0.0
 * @author omarchy
 */

@import url("https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap");

* {
  font-family: 'Inter', sans-serif !important;
  scrollbar-width: none;
}

/* change the accent color from purple to white */
:root {
  --primary-accent-color: #$normal_white;
  --background: rgb($rgb_primary_background);
  --bg-color: rgba($rgb_primary_background, 0.74);
  --bg-color-img: linear-gradient(45deg, #$primary_background, #$primary_background);
  --bg-progress-color: #$normal_black;
  --bg-hover-color: rgba($rgb_primary_background, 0.05);
  --bg-input-color: rgba($rgb_normal_black, 0.74);
  --border-radius: 12px;
  --box-shadow: inset 0 0 0 1px rgba($rgb_normal_white, 0.2),
  0 8px 40px rgba($rgb_primary_background, 0.55);
  --backdrop-filter: blur(16px) saturate(180%);
  --backdrop-filter2: blur(8px) saturate(160%);
}

/* glass effect: */
/*     background: rgba(70, 70, 70, 0.22) !important;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2), 0 4px 16px rgba(0, 0, 0, 0.1), inset 0 1px 0 rgba(255, 255, 255, 0.15), inset 0 -1px 0 rgba(0, 0, 0, 0.1) !important;
    backdrop-filter: var(--backdrop-filter) !important;
    border: 1px solid rgba(255, 255, 255, 0.04) !important; */

html body {
  background: var(--background) !important;
  overflow-y: scroll !important;
}

::-webkit-scrollbar {
  width: 0;  /* removes scrollbar track */
  height: 0;
}

/* ========================= NAV BAR / HEADER ========================= */

.search-bar-container-asfq1 {
    position: fixed;
    bottom: 20px;
    left: 50%;
    transform: translateX(-50%);
    width: 50px; /* Smaller collapsed width - just for icon */
    background: rgba($rgb_normal_black, 0.42) !important;
    border-radius: 999px !important;
    backdrop-filter: blur(8px) saturate(210%) !important;
    opacity: 1 !important;
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 10px;
    z-index: 9999;
    overflow: hidden; /* Hide overflowing content when collapsed */

    /* Smooth animation */
    transition: width 0.4s cubic-bezier(0.4, 0, 0.2, 1) !important;
}

/* Expanded state */
.search-bar-container-asfq1:focus-within,
.search-bar-container-asfq1.expanded {
    width: 30% !important; /* Your original expanded width */
    justify-content: space-between !important;
}

.search-bar-container-asfq1 .submit-button-container-MImNa {
    align-items: center;
    display: flex;
    flex: none;
    flex-direction: row;
    height: var(--search-bar-size);
    justify-content: center;
    padding: 0 0.5rem;
    min-width: 40px; /* Ensure icon always has space */
    order: 2; /* Icon goes to the right when expanded */
}

/* Hide input when collapsed */
.search-bar-container-asfq1 .search-input-IQ0ZW {
    opacity: 0 !important;
    width: 0 !important;
    padding: 0 !important;
    border: none !important;
    background: transparent !important;
    order: 1; /* Input goes to the left when expanded */

    transition: opacity 0.2s ease-in-out 0.15s, width 0.4s cubic-bezier(0.4, 0, 0.2, 1), padding 0.4s cubic-bezier(0.4, 0, 0.2, 1) !important;
}

/* Show input when expanded */
.search-bar-container-asfq1:focus-within .search-input-IQ0ZW,
.search-bar-container-asfq1.expanded .search-input-IQ0ZW {
    opacity: 1 !important;
    width: 100% !important;
    padding: 0 0.5rem 0 0.5rem !important;
    flex: 1 !important;
}

.horizontal-nav-bar-container-Y_zvK .search-bar-h60ja {
    width: 45px !important;
    background: rgba($rgb_normal_black, 0.22) !important;
    border-radius: 999px !important;
    box-shadow: 0 8px 32px rgba($rgb_primary_background, 0.1), 0 2px 8px rgba($rgb_primary_background, 0.05), inset 0 1px 0 rgba($rgb_normal_white, 0.4), inset 0 -1px 0 rgba($rgb_primary_background, 0.1);
    backdrop-filter: blur(4.7px) !important;
    border: 1px solid rgba($rgb_normal_white, 0.2) !important;
    opacity: 1 !important;
    overflow: hidden !important;
    display: flex !important;
    align-items: center !important;
    justify-content: center !important;
    transition: width 0.4s cubic-bezier(0.4, 0, 0.2, 1) !important;
}

/* Expanded state for horizontal nav search bar */
.horizontal-nav-bar-container-Y_zvK .search-bar-h60ja:hover,
.horizontal-nav-bar-container-Y_zvK .search-bar-h60ja:focus,
.horizontal-nav-bar-container-Y_zvK .search-bar-h60ja:focus-within,
.horizontal-nav-bar-container-Y_zvK .search-bar-h60ja.expanded {
    width: 300px !important; /* Expanded width */
    justify-content: space-between !important;
}

/* Hide input when collapsed in horizontal nav */
.horizontal-nav-bar-container-Y_zvK .search-bar-h60ja .search-input-IQ0ZW {
    opacity: 0 !important;
    width: 0 !important;
    padding: 0 !important;
    border: none !important;
    background: transparent !important;

    transition: opacity 0.2s ease-in-out 0.15s, width 0.4s cubic-bezier(0.4, 0, 0.2, 1), padding 0.4s cubic-bezier(0.4, 0, 0.2, 1) !important;
}

/* Show input when expanded in horizontal nav */
.horizontal-nav-bar-container-Y_zvK .search-bar-h60ja:hover .search-input-IQ0ZW,
.horizontal-nav-bar-container-Y_zvK .search-bar-h60ja:focus .search-input-IQ0ZW,
.horizontal-nav-bar-container-Y_zvK .search-bar-h60ja:focus-within .search-input-IQ0ZW,
.horizontal-nav-bar-container-Y_zvK .search-bar-h60ja.expanded .search-input-IQ0ZW {
    opacity: 1 !important;
    width: 100% !important;
    padding: 8px 16px !important;
    flex: 1 !important;
}

/* Keep the search icon visible */
.horizontal-nav-bar-container-Y_zvK .search-bar-h60ja .submit-button-container-MImNa {
    flex-shrink: 0 !important;
    display: flex !important;
    align-items: center !important;
    justify-content: center !important;
    min-width: 35px !important;
    order: 2 !important; /* Icon goes to the right when expanded */
}

/* Style any menu/button container in the top nav */
#app nav[class*="horizontal-nav-bar"] [class*="buttons-container"] > div[class*="button-container"],
#app nav[class*="horizontal-nav-bar"] [class*="buttons-container"] > div[class*="menu-button-container"] {
  background: rgba($rgb_normal_black, 0.22) !important;
  border-radius: 999px !important;
  box-shadow: 0 8px 32px rgba($rgb_primary_background, 0.1), 0 2px 8px rgba($rgb_primary_background, 0.05), inset 0 1px 0 rgba($rgb_normal_white, 0.4), inset 0 -1px 0 rgba($rgb_primary_background, 0.1) !important;
  backdrop-filter: var(--backdrop-filter2) !important;
  border: 1px solid rgba($rgb_normal_white, 0.1) !important;
  transform: scale(0.8) !important;
  opacity: 1 !important;
}

/* Logo styling in header */
#app [class*="horizontal-nav-bar"] [class*="logo-container"] [class*="logo"] {
  filter: grayscale(1) brightness(1) !important;
}

/* ========================= VERTICAL NAV / SIDEBAR ========================= */

/* Position the vertical nav itself */
#app [class*="main-nav-bars-container"] [class*="vertical-nav-bar"] {
  position: absolute !important;
  left: 91px !important;
  top: 0.5px !important;
  z-index: 1 !important;
}

/* Style the vertical nav container (layout, spacing, scroll) */
#app [class*="vertical-nav-bar-container"] {
  align-items: center !important;
  background-color: transparent !important;
  display: flex !important;
  flex-direction: row !important;
  gap: 1rem !important;
  overflow-y: auto !important;
  padding: 1rem 0 !important;
  scrollbar-width: none !important;
  width: auto !important;
  position: relative !important;
}

/* Optional custom label you add in markup */
.nav-label {
  color: var(--primary-accent-color) !important;
  font-weight: 600 !important;
  padding: 0 5px !important;
}

/* Selected tab look */
#app [class*="nav-tab-button-container"].selected {
  background: rgba($rgb_normal_black, 0.22) !important;
  border-radius: 999px !important;
  box-shadow:
    0 8px 32px rgba($rgb_primary_background, 0.2),
    0 4px 16px rgba($rgb_primary_background, 0.1) ,
    inset 0 1px 0 rgba($rgb_normal_white, 0.15) ,
    inset 0 -1px 0 rgba($rgb_primary_background, 0.1) !important;
  backdrop-filter: var(--backdrop-filter) !important;
  border: 1px solid rgba($rgb_normal_white, 0.04) !important;
  opacity: 1 !important;
  transform: translateY(0px) scale(1) !important;
}

/* Ensure nav content is flush left */
#app [class*="main-nav-bars-container"] [class*="nav-content-container"] {
  left: 0 !important;
}

/* Nav button sizing/padding */
#app [class*="vertical-nav-bar-container"] [class*="nav-tab-button"] {
  min-height: auto !important;
  height: auto !important;
  width: auto !important;
  padding: 7px 10px !important;
  transition: padding 0.2s ease-out !important;
}

/* ========================= GENERAL GLASS ELEMENTS ========================= */

/* Apply glass effect to various UI elements */
.nav-menu-container-Pl25j,
.menu-container-B6cqK,
.meta-links-container-dh69_ .links-container-C8Mw9 .link-container-gHxPW,
.meta-preview-container-o22hc .action-buttons-container-XbKVa .action-button-XIZa3.wide,
.meta-preview-container-o22hc .ratings-zUtHH,
.meta-preview-container-o22hc .action-buttons-container-XbKVa .action-button-XIZa3,
.chip-L3r9A.active-jnhyP,
.addon-details-modal-container-aBFaQ .cancel-button-zuUX6,
.modal-container-OuxEF .modal-dialog-container-DZMKq,
.dropdown-MWaxp,
.search-bar-container-p4tSt,
.addons-container-ogGYu .addons-content-zhFBl .selectable-inputs-container-tUul1 .select-input-container-KqG8N,
.add-addon-modal-container-KR5ny .modal-dialog-content-Xgv7Z .addon-url-input-ucetZ:focus,
.add-addon-modal-container-KR5ny .modal-dialog-content-Xgv7Z .addon-url-input-ucetZ:hover,
.option-vFOAS .content-P2T0i .button,
.multiselect-menu-qMdaj .multiselect-button-XXdgA,
.cell-l3eWl.today-G8kuO .heading-TYXvp .day-nttmc,
.shortcut-container-iOrn9 kbd,
.library-container-zM_bj .library-content-PgX4O .selectable-inputs-container-hR3or .select-input-container-H1VZ1 {
    background: rgba($rgb_normal_black, 0.22) !important;
    box-shadow: 0 8px 32px rgba($rgb_primary_background, 0.2), 0 4px 16px rgba($rgb_primary_background, 0.1), inset 0 1px 0 rgba($rgb_normal_white, 0.15), inset 0 -1px 0 rgba($rgb_primary_background, 0.1) !important;
    backdrop-filter: var(--backdrop-filter) !important;
    border: 1px solid rgba($rgb_normal_white, 0.04) !important;
}

/* ========================= PLAY BUTTON STYLING ========================= */

/* Ensure poster container is positioned for absolute overlays */
.meta-item-container-Tj0Ib .poster-container-qkw48 {
    position: relative !important;
    overflow: hidden !important;
}

/* DEFAULT STATE: Center play button */
.meta-item-container-Tj0Ib .poster-container-qkw48 .play-icon-layer-vpQIo {
    position: absolute !important;
    top: 50% !important;
    left: 50% !important;
    transform: translate(-50%, -50%) !important;
    z-index: 10 !important;
    display: flex !important;
    align-items: center !important;
    justify-content: center !important;
    margin: 0 !important;
    padding: 0 !important;
}

/* Hide ALL background layers that create dark squares/boxes behind play button */
.meta-item-container-Tj0Ib .poster-container-qkw48 .play-icon-layer-vpQIo .play-icon-background-Uazjh,
.meta-item-container-Tj0Ib .poster-container-qkw48 .play-icon-layer-vpQIo .play-icon-background-Uazjh::before,
.meta-item-container-Tj0Ib .poster-container-qkw48 .play-icon-layer-vpQIo .play-icon-background-Uazjh::after,
.meta-item-container-Tj0Ib .poster-container-qkw48 .play-icon-layer-vpQIo [class*="background"],
.meta-item-container-Tj0Ib .poster-container-qkw48 .play-icon-layer-vpQIo [class*="backdrop"] {
    display: none !important;
    opacity: 0 !important;
    visibility: hidden !important;
    background: transparent !important;
}

/* Default play button ring - subtle and clean */
.meta-item-container-Tj0Ib .poster-container-qkw48 .play-icon-layer-vpQIo .play-icon-outer-r3iKR {
    background: rgba($rgb_normal_white, 0.3) !important;
    border-radius: 999px !important;
    box-shadow: 0 4px 16px rgba($rgb_primary_background, 0.3), inset 0 1px 0 rgba($rgb_normal_white, 0.5) !important;
    backdrop-filter: blur(12px) saturate(160%) !important;
    border: 1px solid rgba($rgb_normal_white, 0.2) !important;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
}

/* Default play icon color */
.meta-item-container-Tj0Ib .poster-container-qkw48 .play-icon-layer-vpQIo .play-icon-QmEEA {
    color: rgba($rgb_normal_white, 0.9) !important;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
}

/* Create full-poster gray overlay on hover (hidden by default) */
.meta-item-container-Tj0Ib .poster-container-qkw48::before {
    content: '';
    position: absolute !important;
    top: 0 !important;
    left: 0 !important;
    right: 0 !important;
    bottom: 0 !important;
    width: 100% !important;
    height: 100% !important;
    background: rgba($rgb_primary_background, 0.4) !important;
    opacity: 0 !important;
    z-index: 5 !important;
    pointer-events: none !important;
    transition: opacity 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
    border-radius: inherit !important;
}

/* HOVER STATE: Show gray overlay over entire poster */
.meta-item-container-Tj0Ib .poster-container-qkw48:hover::before {
    opacity: 1 !important;
}

/* HOVER STATE: Frosted white glass play button ring */
.meta-item-container-Tj0Ib .poster-container-qkw48:hover .play-icon-layer-vpQIo .play-icon-outer-r3iKR {
    background: rgba($rgb_normal_white, 0.45) !important;
    box-shadow: 0 8px 32px rgba($rgb_primary_background, 0.4), 0 4px 16px rgba($rgb_primary_background, 0.2), inset 0 1px 0 rgba($rgb_normal_white, 0.6), inset 0 -1px 0 rgba($rgb_primary_background, 0.1) !important;
    backdrop-filter: blur(16px) saturate(200%) brightness(110%) !important;
    border: 1.5px solid rgba($rgb_normal_white, 0.5) !important;
    transform: scale(1.02) !important;
}

/* HOVER STATE: Bright white play icon */
.meta-item-container-Tj0Ib .poster-container-qkw48:hover .play-icon-layer-vpQIo .play-icon-QmEEA {
    color: rgba($rgb_normal_white, 1) !important;
    filter: drop-shadow(0 2px 4px rgba($rgb_primary_background, 0.3)) !important;
}

/* ========================= CONTROL BAR STYLING ========================= */

.control-bar-container-xsWA7 .control-bar-buttons-container-SWhkU {
    align-items: center;
    display: flex;
    flex-direction: row;
    background: rgba($rgb_normal_black, 0.22) !important;
    border-radius: 20px !important;
    box-shadow: 0 8px 32px rgba($rgb_primary_background, 0.2), 0 4px 16px rgba($rgb_primary_background, 0.1), inset 0 1px 0 rgba($rgb_normal_white, 0.15), inset 0 -1px 0 rgba($rgb_primary_background, 0.1) !important;
    backdrop-filter: var(--backdrop-filter) !important;
    border: 1px solid rgba($rgb_normal_white, 0.04) !important;
    margin-bottom: 15px !important;
    margin-top: 5px !important;
    height: 50px !important;
}

.slider-container-nJz5F .track-gItfW {
    background: rgba($rgb_normal_white, 0.62) !important;
    border-radius: 999px !important;
    backdrop-filter: var(--backdrop-filter) !important;
    border: 1px solid rgba($rgb_normal_white, 0.04) !important;
    flex: 1;
    height: var(--track-size);
    width: 100%;
    z-index: 0;
}

.seek-bar-container-JGGTa .slider-hBDOf .thumb-PiTF5,
.seek-bar-container-JGGTa .slider-hBDOf .track-after-pUXC0 {
    background-color: #$normal_white !important;
}

.seek-bar-container-JGGTa .slider-hBDOf .thumb-PiTF5:after {
    box-shadow: none;
}

.control-bar-container-xsWA7 .seek-bar-I7WeY {
    --thumb-size: .9rem;
}

.control-bar-container-xsWA7 .control-bar-buttons-container-SWhkU .control-bar-button-FQUsj:hover {
    background: rgba($rgb_normal_white, 0.1) !important;
    box-shadow: 0 4px 16px rgba($rgb_primary_background, 0.15) !important;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
}

/* ========================= SIDE DRAWER STYLING ========================= */

.side-drawer-r9EuA.side-drawer-layer-CZtJ1 {
    background: rgba($rgb_primary_background, 0.85) !important;
    backdrop-filter: blur(20px) saturate(140%) !important;
    border-left: 1px solid rgba($rgb_normal_white, 0.08) !important;
    box-shadow: -4px 0 24px rgba($rgb_primary_background, 0.3) !important;
}

.side-drawer-r9EuA .close-button-ruzkn {
    background: rgba($rgb_normal_black, 0.25) !important;
    border-radius: 999px !important;
    box-shadow: 0 4px 16px rgba($rgb_primary_background, 0.3), inset 0 1px 0 rgba($rgb_normal_white, 0.2) !important;
    backdrop-filter: blur(10px) !important;
    border: 1px solid rgba($rgb_normal_white, 0.1) !important;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
}

.side-drawer-r9EuA .close-button-ruzkn:hover {
    background: rgba($rgb_normal_black, 0.35) !important;
    box-shadow: 0 6px 20px rgba($rgb_primary_background, 0.4), inset 0 1px 0 rgba($rgb_normal_white, 0.3) !important;
    transform: scale(1.05) !important;
}

.side-drawer-r9EuA .video-container-ezBpK {
    background: rgba($rgb_normal_black, 0.2) !important;
    border-radius: 12px !important;
    box-shadow: 0 2px 8px rgba($rgb_primary_background, 0.2), inset 0 1px 0 rgba($rgb_normal_white, 0.08) !important;
    backdrop-filter: blur(8px) !important;
    border: 1px solid rgba($rgb_normal_white, 0.06) !important;
    margin-bottom: 8px !important;
}

.side-drawer-r9EuA .progress-bar-container-w8eFT {
    background: rgba($rgb_normal_white, 0.1) !important;
    border-radius: 2px !important;
    overflow: hidden !important;
}

.side-drawer-r9EuA .progress-bar-E23CT {
    background: rgba($rgb_normal_white, 0.9) !important;
    box-shadow: 0 0 8px rgba($rgb_normal_white, 0.5) !important;
    border-radius: 2px !important;
}

.side-drawer-r9EuA .progress-bar-background-Q7aEH {
    background: rgba($rgb_primary_background, 0.2) !important;
}

.side-drawer-r9EuA .title-container-NcfV9 {
    font-weight: 600 !important;
    color: rgba($rgb_normal_white, 0.95) !important;
}

.side-drawer-r9EuA .released-container-XLPqf {
    color: rgba($rgb_normal_white, 0.6) !important;
    font-size: 11px !important;
}

.side-drawer-r9EuA .side-drawer-meta-preview-pB8v6 {
    background: rgba($rgb_normal_black, 0.25) !important;
    border-radius: 12px !important;
    box-shadow: 0 4px 16px rgba($rgb_primary_background, 0.3), inset 0 1px 0 rgba($rgb_normal_white, 0.1) !important;
    backdrop-filter: blur(12px) !important;
    border: 1px solid rgba($rgb_normal_white, 0.08) !important;
    padding: 16px !important;
    margin-bottom: 16px !important;
}

.side-drawer-r9EuA .description-container-yi8iU {
    color: rgba($rgb_normal_white, 0.8) !important;
    line-height: 1.5 !important;
}

.side-drawer-r9EuA .runtime-label-TzAGI,
.side-drawer-r9EuA .release-info-label-LPJMB {
    color: rgba($rgb_normal_white, 0.7) !important;
    font-size: 13px !important;
}

/* ========================= HERO SECTION STYLING ========================= */

.hero-overlay-button,
.hero-overlay-button-watch {
  border: 0;
  outline: 0;
  padding: 8px 20px;
  display: inline-flex;
  align-items: center;
  gap: 10px;
  font-size: 15px;
  border-radius: 4px;
  cursor: pointer;
  color: #$primary_foreground !important;
  transition: all 0.3s ease;
  background: rgba($rgb_normal_black, 0.22) !important;
  border-radius: 999px !important;
  box-shadow: 0 8px 32px rgba($rgb_primary_background, 0.1), 0 2px 8px rgba($rgb_primary_background, 0.05), inset 0 1px 0 rgba($rgb_normal_white, 0.2), inset 0 -1px 0 rgba($rgb_primary_background, 0.1);
  backdrop-filter: var(--backdrop-filter);
  border: 1px solid rgba($rgb_normal_white, 0.1) !important;
  opacity: 1 !important;
}

.hero-overlay-button-watch {
  background: rgb($rgb_primary_background / 0.41) !important;
  border-radius: 999px !important;
  box-shadow: 0 8px 32px rgba($rgb_primary_background, 0.1), 0 2px 8px rgba($rgb_primary_background, 0.05), inset 0 1px 0 rgba($rgb_normal_white, 0.2), inset 0 -1px 0 rgba($rgb_primary_background, 0.1);
  backdrop-filter: var(--backdrop-filter);
  opacity: 1 !important;
}

.hero-overlay-button-watch:hover,
.hero-overlay-button:hover {
  background: rgba($rgb_normal_white, 0.1) !important;
}

/* ========================= TITLE BAR CONTAINER STYLING ========================= */

/* title container */
[class*="meta-item-container"] [class*="title-bar-container"] {
    display: flex;
    flex-direction: column;
    align-items: stretch;
    justify-content: flex-start;
    height: auto;
    overflow: visible;
    padding: 0;
    position: relative;
}

/* progress-bar container */
[class*="meta-item-container"] [class*="title-bar-container"] [class*="progress-bar-layer"] {
    height: 0.45rem;
    border-radius: 0.45rem;
    overflow: hidden;
    align-self: stretch;
    padding: inherit;
    margin-top: 10px;
    margin-left: 1.8rem;
    margin-right: 1.8rem;
    background-color: rgba($rgb_normal_white, 0.1);
}

/* foreground */
[class*="meta-item-container"] [class*="progress-bar-layer"] [class*="progress-bar-w"] {
    background-color: #$primary_foreground !important;
    height: 100%;
    position: relative;
}

[class*="meta-item-container"] [class*="progress-bar-layer"] [class*="progress-bar-background"] {
    background-color: transparent;
    opacity: 0.3;
    height: 100%;
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
}

[class*="meta-item-container"] [class*="title-bar-container"] > *:not([class*="progress-bar-layer"]) {
    order: 1;
    align-self: stretch;
    display: flex;
    align-items: center;
    margin: none;
    min-height: 1.3rem;
}

.meta-item-container-Tj0Ib .title-bar-container-1Ba0x .menu-label-container-ChuX8 .icon-gh1t9 {
  visibility: hidden;
}

.meta-row-container-xtlB1 .meta-items-container-qcuUA .meta-item-QFHCh.poster-shape-poster-LKBza {
    flex: calc(1 / var(--poster-shape-ratio)) 0 250px !important;
}

.meta-item-container-Tj0Ib {
    overflow: hidden;
}

/* Player menu layer styling */
.player-container-wIELK .layer-qalDW.menu-layer-HZFG9 {
    background: rgba($rgb_normal_black, 0.22) !important;
    border-radius: var(--border-radius) !important;
    box-shadow:
        0 8px 32px rgba($rgb_primary_background, 0.2),
        0 4px 16px rgba($rgb_primary_background, 0.1),
        inset 0 1px 0 rgba($rgb_normal_white, 0.15),
        inset 0 -1px 0 rgba($rgb_primary_background, 0.1) !important;
    backdrop-filter: var(--backdrop-filter) !important;
    border: 1px solid rgba($rgb_normal_white, 0.04) !important;
}

/* Side drawer button layer styling */
.player-container-wIELK .layer-qalDW.side-drawer-button-layer-RrB8k {
    left: initial;
    position: fixed;
    right: -4rem;
    top: 50%;
    transform: translateY(-50%);
    background: rgba($rgb_normal_black, 0.22) !important;
    border-radius: var(--border-radius) !important;
    box-shadow: 0 8px 32px rgba($rgb_primary_background, 0.2), 0 4px 16px rgba($rgb_primary_background, 0.1), inset 0 1px 0 rgba($rgb_normal_white, 0.15), inset 0 -1px 0 rgba($rgb_primary_background, 0.1) !important;
    backdrop-filter: var(--backdrop-filter) !important;
    border: 1px solid rgba($rgb_normal_white, 0.04) !important;
}

[class*="meta-item-container"] [class*="title-bar-container"] [class*="title"],
[class*="meta-item-container"] [class*="title-bar-container"] [class*="title-bar"] {
    margin-top: 0;
    line-height: 1.1;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

[class*="meta-item-container"] [class*="title-bar-container"]:not(:has(> [class*="progress-bar-layer"])) > *:first-child {
    margin-top: 0.35rem;
}

/* ========================= WATCHED FLAGS ========================= */

.upcoming-watched-container-msCaq .watched-container-gvzs3 {
    display: flex !important;
    align-items: center !important;
    gap: 6px !important;
    padding: 6px 12px !important;
    background: rgba($rgb_normal_yellow, 0.35) !important;
    border-radius: 999px !important;
    box-shadow: 0 4px 16px rgba($rgb_primary_background, 0.3), inset 0 1px 0 rgba($rgb_bright_yellow, 0.5) !important;
    backdrop-filter: blur(12px) saturate(160%) !important;
    border: 1px solid rgba($rgb_normal_yellow, 0.4) !important;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
}

.upcoming-watched-container-msCaq .watched-container-gvzs3:hover {
    background: rgba($rgb_normal_yellow, 0.45) !important;
    box-shadow: 0 6px 20px rgba($rgb_primary_background, 0.4), inset 0 1px 0 rgba($rgb_bright_yellow, 0.6) !important;
    backdrop-filter: blur(14px) saturate(180%) brightness(105%) !important;
    border: 1px solid rgba($rgb_normal_yellow, 0.5) !important;
    transform: scale(1.02) !important;
}

.upcoming-watched-container-msCaq .flag-icon-RDrvf {
    width: 14px !important;
    height: 14px !important;
    color: rgba($rgb_normal_white, 0.95) !important;
    filter: drop-shadow(0 1px 2px rgba($rgb_primary_background, 0.3)) !important;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
}

.upcoming-watched-container-msCaq .flag-label-zJloD {
    font-size: 12px !important;
    font-weight: 600 !important;
    color: rgba($rgb_normal_white, 0.95) !important;
    text-shadow: 0 1px 2px rgba($rgb_primary_background, 0.3) !important;
    letter-spacing: 0.3px !important;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
}

.upcoming-watched-container-msCaq .watched-container-gvzs3:hover .flag-icon-RDrvf,
.upcoming-watched-container-msCaq .watched-container-gvzs3:hover .flag-label-zJloD {
    color: rgba($rgb_normal_white, 1) !important;
    filter: drop-shadow(0 2px 3px rgba($rgb_primary_background, 0.4)) !important;
}

/* Upcoming flag - green */
.upcoming-watched-container-msCaq .upcoming-container-LXfQ7 {
    display: flex !important;
    align-items: center !important;
    gap: 6px !important;
    padding: 6px 12px !important;
    background: rgba($rgb_normal_green, 0.35) !important;
    border-radius: 999px !important;
    box-shadow: 0 4px 16px rgba($rgb_primary_background, 0.3), inset 0 1px 0 rgba($rgb_bright_green, 0.5) !important;
    backdrop-filter: blur(12px) saturate(160%) !important;
    border: 1px solid rgba($rgb_normal_green, 0.4) !important;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
}

.upcoming-watched-container-msCaq .upcoming-container-LXfQ7:hover {
    background: rgba($rgb_normal_green, 0.45) !important;
    box-shadow: 0 6px 20px rgba($rgb_primary_background, 0.4), inset 0 1px 0 rgba($rgb_bright_green, 0.6) !important;
    backdrop-filter: blur(14px) saturate(180%) brightness(105%) !important;
    border: 1px solid rgba($rgb_normal_green, 0.5) !important;
    transform: scale(1.02) !important;
}

.upcoming-watched-container-msCaq .upcoming-container-LXfQ7 .flag-label-zJloD {
    font-size: 12px !important;
    font-weight: 600 !important;
    color: rgba($rgb_normal_white, 0.95) !important;
    text-shadow: 0 1px 2px rgba($rgb_primary_background, 0.3) !important;
    letter-spacing: 0.3px !important;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
}

.upcoming-watched-container-msCaq .upcoming-container-LXfQ7:hover .flag-label-zJloD {
    color: rgba($rgb_normal_white, 1) !important;
    filter: drop-shadow(0 2px 3px rgba($rgb_primary_background, 0.4)) !important;
}
EOF
}

# Create the themes directory if it doesn't exist
mkdir -p "$HOME/.config/stremio-enhanced/themes"

# Generate the dynamic theme
create_dynamic_theme

# Send theme change signal to running Stremio instances
if pgrep -x "stremio" > /dev/null 2>&1; then
    echo "Notifying Stremio of theme change..."
    # Use plugin triggerThemeReload to reload theme
    TEMP_SCRIPT="/tmp/stremio-reload-$$.js"
    cat > "$TEMP_SCRIPT" << 'EOF'
if (window.triggerThemeReload) {
    window.triggerThemeReload();
} else {
    console.log('Plugin triggerThemeReload not available');
}
EOF

    echo "Created reload trigger script: $TEMP_SCRIPT"
fi

success "Stremio dynamic theme updated!"
exit 0
