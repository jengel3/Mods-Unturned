module.exports = function(grunt) {
  // project config
  grunt.initConfig({
  	pkg: grunt.file.readJSON('package.json'),
  	emailBuilder: {
  		inline :{
  			files : [{
          expand: true,
          src: ['user_mailer/*.html'],
          dest: 'app/views/',
          ext: '.html.erb'
        }],
        options: {
          encodeSpecialChars: false
        }
      }
    }
  });

  // load email processor
  grunt.loadNpmTasks('grunt-email-builder');

  // Default tasks
  grunt.registerTask('default', ['emailBuilder:inline']);

};