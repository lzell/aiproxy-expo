const { withPodfile } = require("expo/config-plugins");
const { mergeContents } = require("@expo/config-plugins/build/utils/generateCode");

function withAIProxy(config) {
  return withPodfile(config, (config) => {
    config.modResults.contents = mergeContents({
      tag: "aiproxy",
      src: config.modResults.contents,
      newSrc: "  pod 'AIProxy', '0.140.2'",
      anchor: /use_native_modules/,
      offset: 0,
      comment: "#",
    }).contents;
    return config;
  });
}

module.exports = withAIProxy;
