/* user.js */

// fix "welcome to firefox" bullshit
user_pref("trailhead.firstrun.didSeeAboutWelcome", true);
user_pref("doh-rollout.doneFirstRun", true);
user_pref("app.normandy.first_run", false);
user_pref("toolkit.telemetry.reportingpolicy.firstRun", false);
user_pref("browser.feeds.showFirstRunUI", false);
user_pref("browser.startup.homepage_override.mstone", "ignore");

// widevine
user_pref("media.gmp-widevinecdm.version", "system-installed");
user_pref("media.gmp-widevinecdm.visible", true);
user_pref("media.gmp-widevinecdm.enabled", true);
user_pref("media.gmp-widevinecdm.autoupdate", false);
user_pref("media.eme.enabled", true);
user_pref("media.eme.encrypted-media-encryption-scheme.enabled", true);

// general configuration
user_pref("app.shield.optoutstudies.enabled", false);
user_pref("browser.tabs.showAudioPlayingIcon", false);
user_pref("browser.aboutConfig.showWarning", false);
user_pref("browser.discovery.enabled", false);
user_pref("browser.download.autohideButton", false);
user_pref("browser.download.useDownloadDir", true);
user_pref("browser.history.sort_order", "lastvisited");
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.newtabpage.activity-stream.showSearch", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
user_pref("browser.newtabpage.activity-stream.showWeather", false);
user_pref("browser.newtabpage.enabled", false);
user_pref("browser.search.region", "US");
user_pref("browser.sessionstore.closedTabsFromAllWindows", false);
user_pref("browser.sessionstore.closedTabsFromClosedWindows", false);
user_pref("browser.sessionstore.persist_closed_tabs_between_sessions", false);
user_pref("browser.sessionstore.restore_on_demand", false);
user_pref("browser.sessionstore.restore_tabs_lazily", false);
user_pref("browser.sessionstore.resume_from_crash", false);
user_pref("browser.snippets.enabled", false);
user_pref("browser.startup.couldRestoreSession.count", -1); 
user_pref("browser.startup.homepage", "about:newtab");
user_pref("browser.tabs.animate", false);
user_pref("browser.tabs.inTitlebar", 1);
user_pref("browser.tabs.warnOnClose", false);
user_pref("browser.theme.dark-private-windows", false);
user_pref("browser.theme.toolbar-theme", 0);
user_pref("browser.toolbars.bookmarks.visibility", "never");
user_pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"home-button\",\"urlbar-container\",\"ublock0_raymondhill_net-browser-action\",\"unified-extensions-button\",\"downloads-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"vertical-tabs\":[],\"PersonalToolbar\":[\"import-button\",\"personal-bookmarks\"]},\"seen\":[\"save-to-pocket-button\",\"developer-button\",\"ublock0_raymondhill_net-browser-action\"],\"dirtyAreaCache\":[\"nav-bar\",\"vertical-tabs\",\"PersonalToolbar\",\"widget-overflow-fixed-list\",\"toolbar-menubar\",\"TabsToolbar\"],\"currentVersion\":20,\"newElementCount\":6}");
user_pref("browser.uidensity", 0);

user_pref("browser.urlbar.shortcuts.bookmarks", false);
user_pref("browser.urlbar.shortcuts.history", false);
user_pref("browser.urlbar.shortcuts.tabs", true);

user_pref("browser.urlbar.suggest.bookmark", true);
user_pref("browser.urlbar.suggest.engines", false);
user_pref("browser.urlbar.suggest.history", false);
user_pref("browser.urlbar.suggest.searches", false);
user_pref("browser.urlbar.suggest.openpage", false);
user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false);
user_pref("browser.urlbar.suggest.quicksuggest.nonsponsored", false);
user_pref("browser.urlbar.suggest.recentsearches", false);
user_pref("browser.urlbar.suggest.topsites", false);
user_pref("browser.urlbar.suggest.trending", false);

user_pref("browser.urlbar.autoFill.adaptiveHistory.enabled", true);
// user_pref("browser.urlbar.autoFill.enabled", false);
user_pref("browser.urlbar.autoFill", true);
user_pref("browser.urlbar.autocomplete.enabled", true);

user_pref("datareporting.healthreport.service.enabled", false);
user_pref("datareporting.healthreport.service.firstRun", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("datareporting.policy.dataSubmissionPolicyAcceptedVersion", 2);
user_pref("datareporting.policy.dataSubmissionPolicyNotifiedTime", "1533619817422");
user_pref("extensions.autoDisableScopes", 0);
user_pref("extensions.enableScopes", 15);
user_pref("extensions.pictureinpicture.enable_picture_in_picture_overrides", false);
user_pref("extensions.pocket.enabled", false);
user_pref("extensions.recommendations.hideNotice", true);
user_pref("extensions.webextensions.uuids", "{\"default-theme@mozilla.org\":\"0fd28d62-02d4-4ad0-9fac-91a2b500e37c\",\"uBlock0@raymondhill.net\":\"566d2a52-a776-437f-9623-02a97f44bb02\",\"{a34e6974-7b0f-46a8-9092-a970cd732422}\":\"a34e6974-7b0f-46a8-9092-a970cd732422\"}");
user_pref("findbar.highlightAll", true);
user_pref("findbar.modalHighlight", true);
user_pref("findbar.modalHighlight", true);
user_pref("gnomeTheme.activeTabContrast", true);
user_pref("gnomeTheme.allTabsButton", false);
user_pref("gnomeTheme.bookmarksToolbarUnderTabs", false);
user_pref("gnomeTheme.closeOnlySelectedTabs", false);
user_pref("gnomeTheme.dragWindowHeaderbarButtons", true);
user_pref("gnomeTheme.hideSingleTab", false);
user_pref("gnomeTheme.hideWebrtcIndicator", false);
user_pref("gnomeTheme.normalWidthTabs", true);
user_pref("gnomeTheme.noThemedIcons", false);
user_pref("gnomeTheme.oledBlack", false);
user_pref("gnomeTheme.swapTabClose", true);
user_pref("gnomeTheme.symbolicTabIcons", false);
user_pref("gnomeTheme.systemIcons", true);
user_pref("gnomeTheme.tabAlignLeft", true);
user_pref("gnomeTheme.tabsAsHeaderbar", true);
user_pref("media.autoplay.default", 0);
user_pref("media.videocontrols.picture-in-picture.enabled", false);
user_pref("network.buffer.cache.size", 262144);
user_pref("svg.context-properties.content.enabled", true);
user_pref("toolkit.cosmeticAnimations.enabled", false);
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("toolkit.tabbox.switchByScrolling", true);
// user_pref("media.gmp-widevinecdm.enabled", true);
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.server", "");
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.unifiedIsOptIn", false);
user_pref("ui.key.menuAccessKeyFocuses", false);
user_pref("ui.prefersReducedMotion", 1);
user_pref("widget.gtk.rounded-bottom-corners.enabled", true);
