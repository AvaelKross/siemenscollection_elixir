exports.config = {
  // See http://brunch.io/#documentation for docs.
  files: {
    javascripts: {
      joinTo: {
        "js/login.js": /^(js\/((login)|(addict)))/,
        "js/vendor.js": /^(vendor\/js)(?!\/admin)|(deps)|(node_modules\/)/,
        "js/app.js": [/^(js)/],
        "js/jquery-ujs.js.js": ["vendor/js/admin/jquery-ujs.js.js"],
        "js/jquery-ui.min.js": ["vendor/js/admin/jquery-ui.min.js"],
        "js/jquery-ujs.js.js": ["vendor/js/admin/jquery-ujs.js.js"],
        "js/active_admin.js": ["vendor/js/admin/active_admin.js"],
        "js/best_in_place.purr.js": ["vendor/js/admin/best_in_place.purr.js"],
        "js/active_admin_lib.js": ["vendor/js/admin/active_admin_lib.js"],
        "js/best_in_place.js": ["vendor/js/admin/best_in_place.js"]
      },
      // joinTo: "js/app.js",
      // To use a separate vendor.js bundle, specify two files path
      // https://github.com/brunch/brunch/blob/stable/docs/config.md#files
      // joinTo: {
      //  "js/app.js": /^(web\/static\/js)/,
      //  "js/vendor.js": /^(web\/static\/vendor)|(deps)/
      // }
      //
      // To change the order of concatenation of files, explicitly mention here
      // https://github.com/brunch/brunch/tree/master/docs#concatenation
      // order: {
      //   before: [
      //     "web/static/vendor/js/jquery-2.1.1.js",
      //     "web/static/vendor/js/bootstrap.min.js"
      //   ]
      // }
      order: {
        before: [
          "vendor/js/jquery.min.js"
        ]
      }
    },
    stylesheets: {
      joinTo: {
        "css/addict.css": "css/addict.css",
        "css/app.css": /^(css)(?!\/addict.css)/,
        "css/vendor.css": /^(vendor)|(deps)|(node_modules\/)/,
        "css/active_admin.css.css": ["vendor/css/admin/active_admin.css.css"]
      }
    },
    templates: {
      joinTo: "js/app.js"
    }
  },

  conventions: {
    // This option sets where we should place non-css and non-js assets in.
    // By default, we set this to "/assets/static". Files in this directory
    // will be copied to `paths.public`, which is "priv/static" by default.
    assets: /^(static)/
  },

  // Phoenix paths configuration
  paths: {
    // Dependencies and current project directories to watch
    watched: ["static", "css", "js", "vendor"],

    // Where to compile files to
    public: "../priv/static"
  },

  // Configure your plugins
  plugins: {
    babel: {
      // Do not use ES6 compiler in vendor code
      ignore: [/vendor/]
    }
  },

  modules: {
    autoRequire: {
      "js/app.js": ["js/app"],
      "js/login.js": ["js/login"]
    }
  },

  npm: {
    enabled: true,
    // Whitelist the npm deps to be pulled in as front-end assets.
    // All other deps in package.json will be excluded from the bundle.
    whitelist: ["phoenix", "phoenix_html"]
  }
};
