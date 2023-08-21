document.addEventListener('DOMContentLoaded', function() {
  var audio = new Audio('stim/Edoy - Waiting.mp3');
  audio.play()
  audio.addEventListener('ended', function() {
    audio.currentTime = 0;
    audio.play()
  })
})