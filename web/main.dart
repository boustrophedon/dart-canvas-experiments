import 'dart:math';
import 'dart:html';

import 'package:canvas_experiments/exper.dart';


void main() {
  ShiftBlurExper e = new ShiftBlurExper({'pepsi':"Pepsi_logo_2008.svg", 'archlogo':"archlinux-logo.png", 'color_bars':"SMPTE_Color_Bars.svg"});
}

class ShiftBlurExper extends CanvasExperiment {
  var test_img;
  var pixels;
  ShiftBlurExper(Map<String, String> images) : super(images) {}

  List<List<Pixel>> transform_pixels(List<List<Pixel>> pixels) {
    int height = pixels.length;
    int width = pixels.first.length;

    var newpix = new_pixels(height, width);
    for (int i = 0; i < height; i++) {
      var indices = [-10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      var shifts = indices.map((k)=>shift_by(pixels[i],k)).toList();
      for (int j = 0; j<pixels[i].length; j++) {
        Pixel p = pixels[i][j];
        var to_avg = shifts.map( (e) => e[j] ).toList();
        newpix[i][j] = pix_avg_all(p, to_avg);
      }
    }
    return newpix;
  }

  void run() {
    test_img = loader.images['color_bars'];
    window.requestAnimationFrame(render);
  }

  void render(num time) {
    context.clearRect(0,0,canvas.height,canvas.width);

    context.drawImage(test_img, 0,0);

    pixels = parse_image_data(context.getImageData(0,0,test_img.width,test_img.height));

    pixels = transform_pixels(pixels);
    context.putImageData(unparse_image_data(pixels), test_img.width+20, 0);

    window.requestAnimationFrame(render);
  }

}
