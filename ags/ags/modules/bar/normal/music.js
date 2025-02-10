const { GLib } = imports.gi;
import Widget from "resource:///com/github/Aylur/ags/widget.js";
import * as Utils from "resource:///com/github/Aylur/ags/utils.js";
import Mpris from "resource:///com/github/Aylur/ags/service/mpris.js";
const { Box, Button, EventBox, Label, Overlay, Revealer, Scrollable } = Widget;
const { execAsync, exec } = Utils;
import { AnimatedCircProg } from "../../.commonwidgets/cairo_circularprogress.js";
import { MaterialIcon } from "../../.commonwidgets/materialicon.js";
import { showMusicControls } from "../../../variables.js";

const CUSTOM_MODULE_CONTENT_INTERVAL_FILE = `${GLib.get_user_cache_dir()}/ags/user/scripts/custom-module-interval.txt`;
const CUSTOM_MODULE_CONTENT_SCRIPT = `${GLib.get_user_cache_dir()}/ags/user/scripts/custom-module-poll.sh`;
const CUSTOM_MODULE_LEFTCLICK_SCRIPT = `${GLib.get_user_cache_dir()}/ags/user/scripts/custom-module-leftclick.sh`;
const CUSTOM_MODULE_RIGHTCLICK_SCRIPT = `${GLib.get_user_cache_dir()}/ags/user/scripts/custom-module-rightclick.sh`;
const CUSTOM_MODULE_MIDDLECLICK_SCRIPT = `${GLib.get_user_cache_dir()}/ags/user/scripts/custom-module-middleclick.sh`;
const CUSTOM_MODULE_SCROLLUP_SCRIPT = `${GLib.get_user_cache_dir()}/ags/user/scripts/custom-module-scrollup.sh`;
const CUSTOM_MODULE_SCROLLDOWN_SCRIPT = `${GLib.get_user_cache_dir()}/ags/user/scripts/custom-module-scrolldown.sh`;

function trimTrackTitle(title) {
  if (!title) return "";
  const cleanPatterns = [
    /【[^】]*】/, // Touhou n weeb stuff
    " [FREE DOWNLOAD]", // F-777
  ];
  cleanPatterns.forEach((expr) => (title = title.replace(expr, "")));
  return title;
}

const BarGroup = ({ child }) =>
  Box({
    className: "bar-group-margin bar-sides",
    children: [
      Box({
        className: "bar-group bar-group-standalone bar-group-pad-system",
        children: [child],
      }),
    ],
  });

// enum for BarResource
export const BarResourceType = {
  Only_Percentage: 'Percentage',
  Percentage_and_Total: 'Percentage_and_Total',
  // Only_Total: 'Only_Total',
}

export const BarResource = ({
  name,
  icon,
  barResourceType = BarResourceType.Only_Percentage,
  percentageViewCommand,
  totalViewCommand,
  pollDuration = 5000,
  circprogClassName = "bar-batt-circprog",
  textClassName = "txt-onSurfaceVariant",
  iconClassName = "bar-batt"
}) => {
  const resourceCircProg = AnimatedCircProg({
    className: `${circprogClassName}`,
    vpack: "center",
    hpack: "center",
  });
  const resourceProgress = Box({
    homogeneous: true,
    children: [
      Overlay({
        child: Box({
          vpack: "center",
          className: `${iconClassName}`,
          homogeneous: true,
          children: [MaterialIcon(icon, "small")],
        }),
        overlays: [resourceCircProg],
      }),
    ],
  });
  const resourceLabel = Label({
    className: `techfont ${textClassName}`,
  });
  const widget = Button({
    onClicked: () =>
      Utils.execAsync(["bash", "-c", `${userOptions.apps.taskManager}`]).catch(
        print
      ),
    child: Box({
      className: `spacing-h-4 ${textClassName}`,
      children: [resourceProgress, resourceLabel],
      setup: (self) =>
        self.poll(pollDuration, () =>
          execAsync(["bash", "-c", percentageViewCommand])
            .then((percentageOutput) => {
              if (barResourceType === BarResourceType.Only_Percentage) {
                resourceCircProg.css = `font-size: ${Number(percentageOutput)}px;`;
                resourceLabel.label = `${percentageOutput}% `;
                widget.tooltipText = `${name}: ${percentageOutput}%`;
                return;
              }
              execAsync(["bash", "-c", totalViewCommand])
                .then((totalOutput) => {
                  resourceCircProg.css = `font-size: ${Number(percentageOutput)}px;`;
                  totalOutput = totalOutput.replace(/<s>/g, ' ');
                  resourceLabel.label = `${totalOutput} `;
                  widget.tooltipText = `${name}: ${totalOutput}`;
                })
                .catch(print);
            })
            .catch(print)
        ),
    }),
  });
  return widget;
};

const TrackProgress = () => {
  const _updateProgress = (circprog) => {
    const mpris = Mpris.getPlayer("");
    if (!mpris) return;
    // Set circular progress value
    circprog.css = `font-size: ${Math.max(
      (mpris.position / mpris.length) * 100,
      0
    )}px;`;
  };
  return AnimatedCircProg({
    className: "bar-music-circprog",
    vpack: "center",
    hpack: "center",
    extraSetup: (self) =>
      self.hook(Mpris, _updateProgress).poll(3000, _updateProgress),
  });
};

const switchToRelativeWorkspace = async (self, num) => {
  try {
    const Hyprland = (
      await import("resource:///com/github/Aylur/ags/service/hyprland.js")
    ).default;
    Hyprland.messageAsync(
      `dispatch workspace ${num > 0 ? "+" : ""}${num}`
    ).catch(print);
  } catch {
    execAsync([
      `${App.configDir}/scripts/sway/swayToRelativeWs.sh`,
      `${num}`,
    ]).catch(print);
  }
};

export default () => {
  // TODO: use cairo to make button bounce smaller on click, if that's possible
  const playingState = Box({
    // Wrap a box cuz overlay can't have margins itself
    homogeneous: true,
    children: [
      Overlay({
        child: Box({
          vpack: "center",
          className: "bar-music-playstate",
          homogeneous: true,
          children: [
            Label({
              vpack: "center",
              className: "bar-music-playstate-txt",
              justification: "center",
              setup: (self) =>
                self.hook(Mpris, (label) => {
                  const mpris = Mpris.getPlayer("");
                  label.label = `${
                    mpris !== null && mpris.playBackStatus == "Playing"
                      ? "pause"
                      : "play_arrow"
                  }`;
                }),
            }),
          ],
          setup: (self) =>
            self.hook(Mpris, (label) => {
              const mpris = Mpris.getPlayer("");
              if (!mpris) return;
              label.toggleClassName(
                "bar-music-playstate-playing",
                mpris !== null && mpris.playBackStatus == "Playing"
              );
              label.toggleClassName(
                "bar-music-playstate",
                mpris !== null || mpris.playBackStatus == "Paused"
              );
            }),
        }),
        overlays: [TrackProgress()],
      }),
    ],
  });
  const trackTitle = Label({
    hexpand: true,
    className: "txt-smallie bar-music-txt",
    truncate: "end",
    maxWidthChars: 1, // Doesn't matter, just needs to be non negative
    setup: (self) =>
      self.hook(Mpris, (label) => {
        const mpris = Mpris.getPlayer("");
        if (mpris)
          label.label = `${trimTrackTitle(
            mpris.trackTitle
          )} • ${mpris.trackArtists.join(", ")}`;
        else label.label = "No media";
      }),
  });
  const musicStuff = Box({
    className: "spacing-h-10",
    hexpand: true,
    children: [playingState, trackTitle],
  });
  const SystemResourcesOrCustomModule = () => {
    // Check if $XDG_CACHE_HOME/ags/user/scripts/custom-module-poll.sh exists
    if (GLib.file_test(CUSTOM_MODULE_CONTENT_SCRIPT, GLib.FileTest.EXISTS)) {
      const interval =
        Number(Utils.readFile(CUSTOM_MODULE_CONTENT_INTERVAL_FILE)) || 5000;
      return BarGroup({
        child: Button({
          child: Label({
            className: "txt-smallie txt-onSurfaceVariant",
            useMarkup: true,
            setup: (self) =>
              Utils.timeout(1, () => {
                self.label = exec(CUSTOM_MODULE_CONTENT_SCRIPT);
                self.poll(interval, (self) => {
                  const content = exec(CUSTOM_MODULE_CONTENT_SCRIPT);
                  self.label = content;
                });
              }),
          }),
          onPrimaryClickRelease: () =>
            execAsync(CUSTOM_MODULE_LEFTCLICK_SCRIPT).catch(print),
          onSecondaryClickRelease: () =>
            execAsync(CUSTOM_MODULE_RIGHTCLICK_SCRIPT).catch(print),
          onMiddleClickRelease: () =>
            execAsync(CUSTOM_MODULE_MIDDLECLICK_SCRIPT).catch(print),
          onScrollUp: () =>
            execAsync(CUSTOM_MODULE_SCROLLUP_SCRIPT).catch(print),
          onScrollDown: () =>
            execAsync(CUSTOM_MODULE_SCROLLDOWN_SCRIPT).catch(print),
        }),
      });
    } else
      return BarGroup({
        child: Box({
          children: [
            BarResource({
              name: "RAM Usage",
              icon: "memory",
              barResourceType: BarResourceType.Percentage_and_Total,
              percentageViewCommand: `sed -n 1p /dev/shm/system_stats`,
              totalViewCommand: `sed -n 2p /dev/shm/system_stats`,
              circprogClassName: "bar-ram-circprog",
              textClassName: "bar-ram-txt",
              iconClassName: "bar-ram-icon",
            }),
            BarResource({
              name: "Swap Usage",
              icon: "swap_horiz",
              barResourceType: BarResourceType.Only_Percentage,
              percentageViewCommand: `sed -n 3p /dev/shm/system_stats`,
              circprogClassName: "bar-swap-circprog",
              textClassName: "bar-swap-txt",
              iconClassName: "bar-swap-icon"
            }),
            BarResource({
              name: "CPU Usage",
              icon: "ecg_heart",
              barResourceType: BarResourceType.Only_Percentage,
              percentageViewCommand: `sed -n 5p /dev/shm/system_stats`,
              circprogClassName: "bar-cpu-circprog",
              textClassName: "bar-cpu-txt",
              iconClassName: "bar-cpu-icon"
            }),
          ],
        }),
      });
  };
  return EventBox({
    onScrollUp: (self) => switchToRelativeWorkspace(self, -1),
    onScrollDown: (self) => switchToRelativeWorkspace(self, +1),
    child: Box({
      className: "spacing-h-4",
      children: [
        SystemResourcesOrCustomModule(),
        EventBox({
          child: BarGroup({ child: musicStuff }),
          onPrimaryClick: () =>
            showMusicControls.setValue(!showMusicControls.value),
          onSecondaryClick: () =>
            execAsync([
              "bash",
              "-c",
              'playerctl next || playerctl position `bc <<< "100 * $(playerctl metadata mpris:length) / 1000000 / 100"` &',
            ]).catch(print),
          onMiddleClick: () => execAsync("playerctl play-pause").catch(print),
          setup: (self) =>
            self.on("button-press-event", (self, event) => {
              if (event.get_button()[1] === 8)
                // Side button
                execAsync("playerctl previous").catch(print);
            }),
        }),
      ],
    }),
  });
};
