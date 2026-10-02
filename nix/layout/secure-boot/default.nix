# A layout for systems where GRUB refuses to load fonts (for example with Secure Boot enabled). It merges the other two
# layouts: the selected entry's icon is shown big like in teleport, with a list of all entries under it like in classic.
# All text uses whatever font GRUB already has, so no fonts are bundled.
{
  lib,
  hywenhei-extended-font,
  grubTheme,
  component,
  colors,
  colorscheme,
}: let
  inherit (grubTheme) mkComponent rel irel percent;
  resoltions = import ./resolutions {inherit hywenhei-extended-font;};

  # GRUB's built-in font and Fedora's `unicode.pf2` are both 16px
  textHeight = 16;
in
  lib.flip lib.mapAttrs resoltions (resolution: {
    menu,
    fallbackIcon,
    list,
    line,
    elements,
  }: let
    inherit (menu) iconSize;
  in
    component.bundleThemeTxtAssets "grubshin-bootpact-secure-boot-${colorscheme}-${resolution}"
    ({
      image,
      bootMenu,
      ...
    }: {
      menu = bootMenu (menu // {opaqueIcons = true;});
      fallbackIcon = image (fallbackIcon
        // {
          width = iconSize;
          height = iconSize;
        });
      line = image line;
      elements = image elements;
    })
    ({
      menu,
      fallbackIcon,
      line,
      elements,
    }: let
      layout = import ./layout.nix {
        inherit grubTheme lib list line elements textHeight;
        menu = {inherit iconSize;};
      };

      # A text only list of every entry. GRUB can't center menu text, so the list starts at a fixed offset from the
      # center of the screen instead.
      entryList = mkComponent "boot_menu" (layout.list
        // {
          left = irel 50 list.offsetLeft;
          width = rel 50 list.offsetLeft;

          icon_width = 0;
          icon_height = 0;
          item_icon_space = 0;

          item_height = textHeight;
          item_padding = 0;
          item_spacing = list.spacing;

          item_color = colors.medium;
          selected_item_color = colors.text;

          scrollbar = "false";
        });
    in {
      globalProperties = {
        title-text = "";
        desktop-color = colors.background;

        terminal-left = "0";
        terminal-top = "0";
        terminal-width = percent 100;
        terminal-height = percent 100;
      };

      # GRUB draws components in reverse order, so a component is drawn on top of the ones listed after it.
      components =
        [
          (mkComponent "boot_menu" (menu
            // layout.icon
            // {
              item_padding = 0;
              item_icon_space = 0;

              # For some reason we have to move the next item really down so its not rendered
              item_spacing = 99999;

              # Hide the text
              item_color = colors.background;
              selected_item_color = colors.background;
            }))

          # Shown when the selected entry has no icon. It is drawn under the boot menu above, and the icons are opaque
          # so they fully cover it.
          (mkComponent "image" (fallbackIcon // layout.icon))

          entryList

          (mkComponent "label" (layout.countdown
            // {
              id = "__timeout__";
              text = "Booting selected entry in %d";
              color = colors.bright;
              align = "center";
            }))
        ]
        ++ (lib.imap0 (i: text:
            mkComponent "label" ((builtins.elemAt layout.tooltips i)
              // {
                inherit text;
                color = colors.bright;
                align = "center";
              }))
          (lib.splitString "\n" ''
            Use the ↑ and ↓ keys to select an entry. Press enter to
            boot the selected OS, 'e' to edit the commands before booting,
            'c' for a command-line and ESC to return to previous menu.''))
        ++ [
          (mkComponent "image" (line // layout.line-left))
          (mkComponent "image" (elements // layout.elements))
          (mkComponent "progress_bar" (layout.elements
            // {
              id = "__timeout__";
              text = "";

              fg_color = colors.elements-filled;
              bg_color = colors.elements-empty;
              border_color = colors.background;
            }))
          (mkComponent "image" (line // layout.line-right))
        ];
    }))
