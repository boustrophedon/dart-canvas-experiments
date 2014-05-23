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
      for (int j = 0; j < width; j++) {
        int uoff = max(i-1,0);
        int doff = min(i+1,height-1);
        int loff = max(j-1,0);
        int roff = min(j+1,width-1);

        Pixel u = pixels[uoff][j];
        Pixel d = pixels[doff][j];
        Pixel l = pixels[i][loff];
        Pixel r = pixels[i][roff];

        int red = ((u.r+d.r+l.r+r.r)/4).toInt();
        int green = ((u.g+d.g+l.g+r.g)/4).toInt();
        int blue = ((u.b+d.b+l.b+r.b)/4).toInt();
        int alpha = ((u.a+d.a+l.a+r.a)/4).toInt();

        newpix[i][j] = new Pixel(red, green, blue, alpha);
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
