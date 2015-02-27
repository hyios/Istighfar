
// Project configuration.
var pkg = require('./package.json');

module.exports = function(grunt) {

  grunt.initConfig({

    // Various Grunt tasks...

    buildcontrol: {
      options: {
        dir: '_site',
        commit: true,
        push: true,
        message: 'Built %sourceName% from commit %sourceCommit% on branch %sourceBranch%'
      },
      pages: {
        options: {
          remote: 'git@github.com:hyios/Istighfar.git',
          branch: 'gh-pages'
        }
      },
      local: {
        options: {
          remote: '../',
          branch: 'build'
        }
      }
    }
  });

  grunt.loadNpmTasks('grunt-build-control');
  grunt.registerTask('build', []);
  grunt.registerTask('deploy', ['build', 'buildcontrol:pages']);
  grunt.registerTask('default', ['build']);

};
