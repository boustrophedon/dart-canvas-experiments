import 'dart:html';
import 'dart:math';

import 'package:canvas_experiments/exper.dart';


void main() {
  var e = new CascadeExper({'pepsi':"Pepsi_logo_2008.svg", 'archlogo':"archlinux-logo.png", 'color_bars':"SMPTE_Color_Bars.svg"});
}

class CascadeExper extends CanvasExperiment {
  var test_img;
  var pepsi_img;
  var pixels;

  CascadeExper(Map<String, String> images) : super(images) {}

  List<List<Pixel>> transform_pixels(List<List<Pixel>> pix) {
    int height = pix.length;
    int width = pix.first.length;

    var newpix = new_pixels(height, width);
    for (int i = 0; i < height; i++) {
      for (int j = 0; j< width; j++) {
        Pixel p = pix[i][j];
        var j1 = max(j-1, 0);
        var j2 = min(j+1, width-1);
        var i1 = max(i-1, 0);
        var i2 = min(i+1, height-1);
        newpix[i][j] = pix_avg(pix_avg(pix[i][j1], pix[i][j2]), pix_avg(pix[i1][j], pix[i2][j]));
      }
    }
    return newpix;
  }

  void run() {
    test_img = loader.images['color_bars'];
    pepsi_img = loader.images['pepsi'];

    context.clearRect(0,0,canvas.height,canvas.width);
    context.drawImage(test_img, 0,0);
    window.requestAnimationFrame(render);
  }

  void render(num time) {

    var pix = parse_image_data(context.getImageData(0,0,test_img.width,test_img.height));

    pixels = transform_pixels(pix);
    context.putImageData(unparse_image_data(pixels), 0, 0);

    window.requestAnimationFrame(render);
  }

}
