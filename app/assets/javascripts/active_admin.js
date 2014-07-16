//= require jquery
//= require jquery_ujs
//= require jquery.cookie
//= require json/json2
//= require tinymce-jquery
//= require active_admin/base

$(document).ready(function() {
  tinyMCE.init({
    selector: 'textarea.tinymce',
    plugins: 'advlist autolink lists link image anchor code media paste',
    menubar: false,
    toolbar: [
      'undo redo | styleselect | bold italic underline strikethrough | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image media'
    ]
  });
});
