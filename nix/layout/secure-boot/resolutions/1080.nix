{hywenhei-extended-font}: let
  svg = path: ../../../../svg + path;
in {
  menu = {
    icons = svg /icons;
    iconSize = 200;
  };

  # Shown for entries without an icon
  fallbackIcon = {
    src = svg /icons/efi.svg;
    name = "fallback-icon";
  };

  list = {
    # Space between the icon and the list
    gap = 30;
    # How many entries fit before the list scrolls
    entries = 8;
    spacing = 8;
    # The list is drawn left-aligned with a fixed 16px font (8px per character), so this centers a ~62 character title
    # such as `Fedora Linux (7.2.7-200.fc44.x86_64) 44 (Workstation Edition)`
    offsetLeft = 248;
  };

  line = {
    src = svg /progress-bar/line.svg;
    name = "line";
    width = 1;
    height = 2;
  };

  elements = {
    src = svg /progress-bar/seven-elements.svg;
    name = "elements";
    width = 350;
    height = 47;
  };
}
