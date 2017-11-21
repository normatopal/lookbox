jQuery ->
  new CarrierWaveCropper()

class CarrierWaveCropper
  constructor: ->
    $('#picturedecorator_image_cropbox').Jcrop
      aspectRatio: 1
      setSelect: [0, 0, 200, 200]
      onSelect: @update
      onChange: @update

  update: (coords) =>
    $('#picturedecorator_image_crop_x').val(coords.x)
    $('#picturedecorator_image_crop_y').val(coords.y)
    $('#picturedecorator_image_crop_w').val(coords.w)
    $('#picturedecorator_image_crop_h').val(coords.h)
    @updatePreview(coords)

  updatePreview: (coords) =>
    $('#picturedecorator_image_previewbox').css
      width: Math.round(100/coords.w * $('#picturedecorator_image_cropbox').width()) + 'px'
      height: Math.round(100/coords.h * $('#picturedecorator_image_cropbox').height()) + 'px'
      marginLeft: '-' + Math.round(100/coords.w * coords.x) + 'px'
      marginTop: '-' + Math.round(100/coords.h * coords.y) + 'px'
