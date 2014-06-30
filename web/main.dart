import 'dart:html';
import 'dart:math';

import 'package:canvas_experiments/exper.dart';


void main() {
  var e = new RandomReplaceExper({'pepsi':"Pepsi_logo_2008.svg", 'archlogo':"archlinux-logo.png", 'color_bars':"SMPTE_Color_Bars.svg", 'islet':"islet.jpg"});
}

class RandomReplaceExper extends CanvasExperiment {
  var render_img;

  Random rng;

  var pixels;

  int iter = 10;

  RandomReplaceExper(Map<String, String> images) : super(images) {
    rng = new Random();
  }

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
        var p1 = pix[i][j1];
        var p2 = pix[i][j2];
        var p3 = pix[i1][j];
        var p4 = pix[i2][j];
        newpix[i][j] = choose([p1,p2,p3,p4], rng);
      }
    }
    return newpix;
  }

  void run() {
    var test_img = loader.images['color_bars'];
    var pepsi_img = loader.images['pepsi'];
    var arch_img = loader.images['archlogo'];
    var islet_img = loader.images['islet'];

    render_img = islet_img;

    context.clearRect(0,0,canvas.height,canvas.width);
    context.drawImage(render_img, 0,0);
    window.requestAnimationFrame(render);
  }

  void render(num time) {

    var pix = parse_image_data(context.getImageData(0,0,render_img.width,render_img.height));

    pixels = transform_pixels(pix);
    context.putImageData(unparse_image_data(pixels), 0, 0);

    if (iter > 0) {
      window.requestAnimationFrame(render);
      iter--;
    }
  }

}
