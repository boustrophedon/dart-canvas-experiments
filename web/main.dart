import 'dart:math' show Random;
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

  void transform_pixels(List<List<Pixel>> pixels) {

    int width = pixels.first.length;
    int height = pixels.length;
    for (int i = 0; i < height; i++) {
      for (int j = 0; j < width; j++) {
        // this does what it does because the background is transparent
        Pixel p = pixels[i][j];
        p.r = rng.nextInt(255);
        p.b = rng.nextInt(255);
        p.g = rng.nextInt(255);
      }
    }
  }

  void run() {
    pepsi = loader.images['pepsi'];
    window.requestAnimationFrame(render);
  }

  void render(num time) {
    context.clearRect(0,0,canvas.height,canvas.width);

    context.drawImage(pepsi, 0,0);

    pixels = parse_image_data(context.getImageData(0,0,pepsi.width,pepsi.height));

    transform_pixels(pixels);
    context.putImageData(unparse_image_data(pixels), pepsi.width+20, 0);

    window.requestAnimationFrame(render);
  }

}
