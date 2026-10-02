{hywenhei-extended-font}: let
  svg = path: ../../../../svg + path;
in {
  logo = {
    src = svg /logo.svg;
    name = "logo";
    width = 462;
    height = 140;
  };

  menu = {
    icons = svg /icons;
    iconSize = 84;
  };

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
