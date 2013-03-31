module.exports = (grunt) ->
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-uglify'
	grunt.loadNpmTasks 'grunt-contrib-watch'

	grunt.initConfig
		pkg: grunt.file.readJSON('package.json')
		coffee:
			build:
				files:
					'build/l10n.js': 'src/l10n.coffee'
					'tmp/l10n-tools.js': 'src/l10n-tools.coffee'
					'build/l10n-export.js': 'src/l10n-export.coffee'
					'build/l10n-with-tools.js': ['src/l10n.coffee', 'src/l10n-tools.coffee']
		uglify:
			build:
				options: {
					banner: '/*!\n
 * <%= pkg.name %> <%= pkg.version %> <%= grunt.template.today("yyyy-mm-dd") %>\n
 * Copyright 2013 Andrew Kulinich. Released under the MIT license\n
 */\n'
				}
				files:
					'build/l10n.min.js': ['build/l10n.js']
					'build/l10n-with-tools.min.js': ['build/l10n.js', 'tmp/l10n-tools.js']
		watch:
			src:
				files: [
					'src/*.coffee'
					'src/*.js'
				]
				tasks: ['default']

	grunt.registerTask('default', ['coffee', 'uglify'])
