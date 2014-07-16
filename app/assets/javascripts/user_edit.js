

$(document).ready(function() {

    refreshMembershipOptions();

    $('.AvatarSelect').click(function() {

      var linkObj = $(this);
      linkObj.text("Fetching...");
      $.post(linkObj.attr("href"), { 'avatar' : linkObj.data("avatar") }, 
        function(data, textStatus, jqXHR)
        {
          linkObj.text("Use Avatar");
          $('.profile_pic').css('background-image', "url('"+data.avatar+"')");
        });

      return false;
    }); 

    $('.AuthenticationCheckin').click(function() {
      var values = { 'id' : $(this).attr('auth'),
                     'checkin' : $(this).is(':checked') };
                     
      $.post("/auth/checkin", 
        values,
        function(data){
               
        });
    });

    $('.AuthenticationDelete').click(function() {
      $(this).text("Please Wait.");
      var provider = $(this).attr('id');
      $.ajax({
              url: '/authentications/' + provider,
              type: 'post',
              dataType: 'json',
              data: { '_method': 'delete' },
              success: function(data, textStatus, jqXHR) {
                 $('#' + data.provider + '-options').fadeOut(function() { $('#' + data.provider + '-connect').fadeIn(); });
                 
              },
              error: function() {
                  
              }
          });
    });
});