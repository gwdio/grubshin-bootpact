{hywenhei-extended-font}: let
  svg = path: ../../../../svg + path;
in {
  menu = {
    icons = svg /icons;
    iconSize = 280;
  };

  # Keeps the boot entry title lined up with the tip text at this font size
  menuCenterOffsetLeft = 420;

  line = {
    src = svg /progress-bar/line.svg;
    name = "line";
    width = 1;
    height = 3;
  };

  elements = {
    src = svg /progress-bar/seven-elements.svg;
    name = "elements";
    width = 490;
    height = 66;
  };

  fonts.normal = {
    size = 28;
    src = "${hywenhei-extended-font}/HYWenHei Extended.ttf";
    family = "HY WenHei Extended";
  };
  fonts.header = {
    size = 31;
    src = "${hywenhei-extended-font}/HYWenHei Extended.ttf";
    family = "HY WenHei Extended";
  };
}
