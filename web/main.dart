import 'dart:math' show Random, min, max;
import 'dart:html';

import 'package:canvas_experiments/exper.dart';


void main() {
  RandomExper e = new RandomExper();
}

class RandomExper extends CanvasExperiment {
  Random rng;
  var pepsi;
  var pixels;
  RandomExper() : super() {
    rng = new Random();
  }

  List<List<Pixel>> transform_pixels(List<List<Pixel>> pixels) {
    int height = pixels.length;
    int width = pixels.first.length;

    var newpix = new_pixels(height, width);
    for (int i = 0; i < height; i++) {
      var rshift = shift_by(pixels[i],1);
      var lshift = shift_by(pixels[i],-1);
      for (int j = 0; j<pixels[i].length; j++) {
        Pixel p = pixels[i][j];
        newpix[i][j] = pix_avg(pix_avg(p, lshift[j]), rshift[j]);
      }
    }
    return newpix;
  }

  void run() {
    pepsi = loader.images['pepsi'];
    window.requestAnimationFrame(render);
  }

  void render(num time) {
    context.clearRect(0,0,canvas.height,canvas.width);

    context.drawImage(pepsi, 0,0);

    pixels = parse_image_data(context.getImageData(0,0,pepsi.width,pepsi.height));

    pixels = transform_pixels(pixels);
    context.putImageData(unparse_image_data(pixels), pepsi.width+20, 0);

    window.requestAnimationFrame(render);
  }

}
