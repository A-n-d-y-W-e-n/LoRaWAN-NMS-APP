$(document).on("click", ".alert", function(e) {
            bootbox.alert("Hello world!", function() {
                console.log("Alert Callback");
            });
        });

$(document).on("click", ".confirm", function(e) {
            var _this = this;
            e.preventDefault();
            bootbox.confirm({
                message: "Are you sure?",
                buttons: {
                    confirm: {
                        label: 'Yes',
                        className: 'btn-success'
                    },
                    cancel: {
                        label: 'No',
                        className: 'btn-danger'
                    }
                },
                callback: function (result) {
                  if (result) {
                      $(_this).closest('form').submit();
                  }
                }
            });
        });

// $(function(){
//     $('.confirm').click(function(e){
//         var _this = this;
//         e.preventDefault();
//         bootbox.confirm("Are you sure?", function(result) {
//             if (result) {
//                 $(_this).closest('form').submit();
//             }
//         });
//     });
// });

// $('form').submit(function(e) {
//         var currentForm = this;
//         e.preventDefault();
//         bootbox.confirm("Are you sure?", function(result) {
//             if (result) {
//                 currentForm.submit();
//             }
//         });
//     });
