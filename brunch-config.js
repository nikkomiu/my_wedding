exports.config = {
  // See http://brunch.io/#documentation for docs.
  files: {
    javascripts: {
      joinTo: "js/app.js"

      // joinTo: {
      //   "js/app.js": /^(web\/static\/js|node_modules\/phoenix.*)/,
      //   "js/vendor.js": /^bower_components/
      // }

      // To change the order of concatenation of files, explicitly mention here
      //order: {
      //  before: [
      //    "web/static/vendor/js/jquery-2.1.1.js",
      //    "web/static/vendor/js/bootstrap.min.js"
      //  ]
      //}
    },
    stylesheets: {
      joinTo: "css/app.css",
      order: {
        after: ["web/static/sass/app.scss"] // concat app.css last
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
    assets: /^(web\/static\/assets)/,
    ignored: [
      "bower_components/Materialize/bin/materialize.css",
      /web\/static\/sass\/_.*\.(scss|sass)/
    ]
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
      ignore: [
        /web\/static\/vendor/,
        /bower_components/
      ]
    },
    sass: {
      mode: 'ruby', // ruby or native
      options: {
        includePaths: ["bower_components/Materialize/sass"]
      }
    }
  },

  modules: {
    autoRequire: {
      "js/app.js": ["web/static/js/app"]
    }
  },

  npm: {
    enabled: true
  }
};
