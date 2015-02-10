$window = $(window)
$body   = $('body')
windowHeight = 0
windowWidth = 0
bodyHeight = 0


letters = 'hello'
letterTemplate =
  '''
    <div class="letter-<%= letter %>">
      <%= letter %>
    </div>
  '''


keyframes = (
  {
    selector: "letter-#{letter}"
    duration: 1.5  # 1 = 100% of the body's height
    'animations': [
      translateY: -100
      translateX: 100
      opacity: [0.5]
    ]
  } for letter in letters
)

templates = (_.template(letterTemplate)({letter}) for letter in letters)

buildPage = ->
  windowHeight = $window.height()
  console.log keyframes
  for keyframe, index in keyframes
    console.log keyframe
    bodyHeight += keyframes[index].duration * windowHeight
    $('.parallax').append templates[index]
  console.log 'hi', bodyHeight
  $body



animate = ->
setKeyFrame = ->

update = ->
  window.requestAnimationFrame ->
    scrollTop = $window.scrollTop()
    # console.log scrollTop
    console.log bodyHeight - windowHeight
    if scrollTop > 0 and scrollTop <= (bodyHeight - windowHeight)
      console.log 'requested animation frame'
      animate()
      setKeyFrame()

init = ->
  $(document).scroll _.throttle update, 10
  buildPage()

$ ->
  init()
