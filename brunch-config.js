exports.config = {
  // See http://brunch.io/#documentation for docs.
  files: {
    javascripts: {
      joinTo: {
        "js/login.js": /^(web\/static\/js\/((login)|(addict)))/,
        "js/vendor.js": /^(web\/static\/vendor\/js)(?!\/admin)|(deps)|(node_modules\/)/,
        "js/app.js": [/^(web\/static\/js)/],
        "js/jquery-ujs.js.js": ["web/static/vendor/js/admin/jquery-ujs.js.js"],
        "js/jquery-ui.min.js": ["web/static/vendor/js/admin/jquery-ui.min.js"],
        "js/jquery-ujs.js.js": ["web/static/vendor/js/admin/jquery-ujs.js.js"],
        "js/active_admin.js": ["web/static/vendor/js/admin/active_admin.js"],
        "js/best_in_place.purr.js": ["web/static/vendor/js/admin/best_in_place.purr.js"],
        "js/active_admin_lib.js": ["web/static/vendor/js/admin/active_admin_lib.js"],
        "js/best_in_place.js": ["web/static/vendor/js/admin/best_in_place.js"]
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
          "web/static/vendor/js/jquery.min.js"
        ]
      }
    },
    stylesheets: {
      joinTo: {
        "css/addict.css": "web/static/css/addict.css",
        "css/app.css": /^(web\/static\/css)(?!\/addict.css)/,
        "css/vendor.css": /^(web\/static\/vendor)|(deps)|(node_modules\/)/,
        "css/active_admin.css.css": ["web/static/vendor/css/admin/active_admin.css.css"]
      }
    },
    templates: {
      joinTo: "js/app.js"
    }
  },

  conventions: {
    // This option sets where we should place non-css and non-js assets in.
    // By default, we set this to "/web/static/assets". Files in this directory
    // will be copied to `paths.public`, which is "priv/static" by default.
    assets: /^(web\/static\/assets)/
  },

  // Phoenix paths configuration
  paths: {
    // Dependencies and current project directories to watch
    watched: [
      "web/static",
      "test/static"
    ],

    // Where to compile files to
    public: "priv/static"
  },

  // Configure your plugins
  plugins: {
    babel: {
      // Do not use ES6 compiler in vendor code
      ignore: [/web\/static\/vendor/]
    }
  },

  modules: {
    autoRequire: {
      "js/app.js": ["web/static/js/app"],
      "js/login.js": ["web/static/js/login"]
    }
  },

  npm: {
    enabled: true,
    // Whitelist the npm deps to be pulled in as front-end assets.
    // All other deps in package.json will be excluded from the bundle.
    whitelist: ["phoenix", "phoenix_html", "turbolinks"]
  }
};
