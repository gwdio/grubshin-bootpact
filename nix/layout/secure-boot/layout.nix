{
  grubTheme,
  lib,
  menu,
  list,
  line,
  elements,
  textHeight,
}: let
  inherit (grubTheme) rel irel percent;
in
  (lib.pipe {}
    (builtins.map
      (stepfn: args: let
        result = stepfn args;
      in
        lib.recursiveUpdate args result)
      [
        ({...}: {
          # The icon sits right above the center of the screen and the list of entries right below it
          out.icon = {
            left = irel 50 (menu.iconSize / 2);
            top = irel 50 menu.iconSize;
            width = menu.iconSize;
            height = menu.iconSize;
          };

          out.list = {
            top = rel 50 list.gap;
            height = list.entries * (textHeight + list.spacing);
          };
        })

        ({bottom ? 0, ...}: let
          vpad = elements.height / 3;
          hpad = elements.width / 2 + 20;

          lineTop = irel 100 (bottom + vpad + (elements.height - line.height) / 2 + line.height);
          lineWidth = irel 50 hpad;
        in {
          bottom = bottom + elements.height + vpad;

          out.elements = {
            left = irel 50 (elements.width / 2);
            top = irel 100 (bottom + elements.height + vpad);
            inherit (elements) width height;
          };

          out.line-left = {
            left = 0;
            width = lineWidth;
            top = lineTop;
            inherit (line) height;
          };

          out.line-right = {
            left = rel 50 hpad;
            width = lineWidth;
            top = lineTop;
            inherit (line) height;
          };
        })

        ({bottom ? 0, ...}: let
          lines = 3;
          spacing = 1.3;
          padding = 40;
        in {
          bottom = bottom + padding + textHeight * spacing * lines;

          out.tooltips =
            builtins.genList (
              fromBottom: let
                i = lines - fromBottom;
              in {
                left = 0;
                width = percent 100;
                top = irel 100 (bottom + padding + textHeight * spacing * i);
                height = textHeight;
              }
            )
            lines;
        })

        ({bottom ? 0, ...}: let
          padding = textHeight;
        in {
          bottom = bottom + padding + textHeight;

          out.countdown = {
            left = 0;
            width = percent 100;
            top = irel 100 (bottom + padding + textHeight);
            height = textHeight;
          };
        })
      ]))
  .out
