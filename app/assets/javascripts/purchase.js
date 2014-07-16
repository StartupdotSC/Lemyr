$(document).ready(function() {

    $(".home #payment_option[value=new]").click(function(){ $('#CCForm').show(); })
    $(".home #payment_option[value=file]").click(function(){ $('#CCForm').hide(); })


    $(".home #transfer-form").submit(function(event) {

      $(".transfer-errors").text("");
      $(".transfer-errors").hide();

      $(".transfer-info").text("");
      $(".transfer-info").hide();

      $('.submit-button').attr("disabled", "disabled");
      $('#TransferSubmit').text("Please Wait...");

      var data = $(this).serialize();
      $.post('/transfer',
        data, 
        function(data, textStatus, jqXHR)
        {
            if (data.result != "success")
            {
              $(".transfer-errors").text(data.result);
              $(".transfer-errors").fadeIn();
            } else {
               $(".transfer-info").text("Your transfer was successful!");
               $("#to_email").val("");
               $(".transfer-info").fadeIn();
            }

            $(".submit-button").removeAttr("disabled");
            $('#TransferSubmit').text("Transfer More");
            UpdateDaypassBalance();
        });// post


      // prevent the form from submitting with the default action
      return false;
    });

      // handle the form submission
    $(".home #payment-form").submit(function(event) {

      $(".payment-errors").text("");
      $(".payment-errors").hide();

      $(".payment-info").text("");
      $(".payment-info").hide();
      
      $('.submit-button').attr("disabled", "disabled");
      $('#CCSubmit').text("Please Wait...");

      var data = $(this).serialize();
      $.post('/purchase',
        data, 
        function(data, textStatus, jqXHR)
        {
            if (data.result != "success")
            {
              $(".payment-errors").text(data.result);
              $(".payment-errors").fadeIn();
            } else {
               $("#CCForm").hide();
               $(".payment-info").text("Your purchase was successful!");
               $(".payment-info").fadeIn();
            }

            $(".submit-button").removeAttr("disabled");
            $('#CCSubmit').text("Purchase More");
            UpdateDaypassBalance();
        });// post


      // prevent the form from submitting with the default action
      return false;
    });
});