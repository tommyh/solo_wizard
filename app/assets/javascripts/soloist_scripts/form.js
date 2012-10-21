$(document).ready(function(){

  $("#new_soloist_script .recipe-details").each(function(){
    $(this).click(function(e){ e.preventDefault(); });

    var recipeDetails = $(this).data("details");

    var qTipOptions = {
      content: {
        text: recipeDetails.description,
        title: { text: recipeDetails.title, button: "Close" }
      },
      position: {
        corner: { target: "bottomMiddle", tooltip: "topMiddle" },
        adjust: { screen: true }
      },
      show: { when: "click", solo: true },
      hide: "unfocus",
      style: {
        tip: true,
        border: { width: 0, radius: 4},
        name: "light",
        width: 570
      }
    };

    $(this).qtip(qTipOptions);
  });

  var isTouchDevice = !!('ontouchstart' in window);
  if(isTouchDevice){
    $("html").addClass("touch");
  } else {
    $("html").addClass("no-touch");
  }

});