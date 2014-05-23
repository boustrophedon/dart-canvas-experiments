import 'dart:html';
import 'dart:async';


class Pixel {
  int r;
  int g;
  int b;
  int a;
  Pixel(this.r, this.g, this.b, this.a);
  Pixel.fromPixel(Pixel o) {
    r = o.r;
    g = o.g;
    b = o.b;
    a = o.a;
  }
  Pixel.zero() : r=0, g=0, b=0, a=0;
}

Pixel pix_avg(Pixel p1, Pixel p2) {
  int r = ((p1.r + p2.r)~/2);
  int g = ((p1.g + p2.g)~/2);
  int b = ((p1.b + p2.b)~/2);
  int a = ((p1.a + p2.a)~/2);
  return new Pixel(r,g,b,a);
}

Pixel pix_avg_all(Pixel p, List<Pixel> pix) {
  pix.add(p);
  int l = pix.length;
  int r=0,g=0,b=0,a=0;
  for (Pixel o in pix) {
    r+=o.r;
    g+=o.g;
    b+=o.b;
    a+=o.a;
  }
  return new Pixel(r~/l, b~/l, g~/l, a~/l);
}

List<Pixel> shift_by(List<Pixel> l, int shift) {
  List<Pixel> shifted = new List<Pixel>();
  for (int i = 0; i < l.length; i++) {
    if (i+shift >=0 && i+shift < l.length) {
      shifted.add(l[i+shift]);
    }
    else {
      shifted.add(new Pixel.zero());
    }
  }
  return shifted;
}


class ImageLoader {
  Map<String, ImageElement> images;
  Function complete;

  int total;

  ImageLoader(Function on_completion, Map<String,String> load) {
    images = new Map<String, ImageElement>();
    var futures = new List<Future<Event>>();

    for (String img in load.keys) {
      // because of cors this doesn't work for arbitrary urls
      // workaround: upload to imgur and then grab the image data from there
      // add new_image.crossOrigin = "Anonymous" i think
      ImageElement new_image = new ImageElement(src: load[img]);
      images[img] = new_image;
      futures.add(new_image.onLoad.first);
    }
    Future.wait(futures).then((e) => on_completion());
  }
}

abstract class CanvasExperiment {
  CanvasElement canvas;
  CanvasRenderingContext2D context;
  ImageLoader loader;

  CanvasExperiment(Map<String, String> images) {
    canvas = querySelector("#area");
    canvas.height = window.innerHeight;
    canvas.width = window.innerWidth;

    context = canvas.context2D;

    loader = new ImageLoader(this.run, images);
  }

  List<List<Pixel>> new_pixels(int height, int width) {
    var pixels = new List<List<Pixel>>(height);
    for (int i = 0; i< height; i++) {
      pixels[i] = new List<Pixel>(width);
    }
    return pixels;
  }

  List<List<Pixel>> parse_image_data(ImageData data) {
    var pixels = new_pixels(data.height, data.width);

    var d = data.data;

    int stride = 4;
    for (int i = 0; i < data.height; i++) {
      for (int j = 0; j < data.width; j++) {
        int index = (i*(data.width)*stride) + (j*stride);
        Pixel p = new Pixel(d[index], d[index+1], d[index+2], d[index+3]);

        pixels[i][j] = p;
      }
    }
    return pixels;
  }

  ImageData unparse_image_data(List<List<Pixel>> pixels) {
    int width = pixels.first.length;
    int height = pixels.length;

    var new_data = context.createImageData(width, height);
    int stride = 4;

    for (int i = 0; i < height; i++) {
      for (int j = 0; j < width; j++) {
        int index = (i*(width)*stride) + (j*stride);
        new_data.data[index] = pixels[i][j].r;
        new_data.data[index+1] = pixels[i][j].g;
        new_data.data[index+2] = pixels[i][j].b;
        new_data.data[index+3] = pixels[i][j].a;
      }
    }
    return new_data;
  }


  void run() {
    window.requestAnimationFrame(render);
  }

  void render(num time);
} 
