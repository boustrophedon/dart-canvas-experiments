import 'dart:html';

class Pixel {
  int r;
  int g;
  int b;
  int a;
  Pixel(this.r, this.g, this.b, this.a);
}

class ImageLoader {
  Map<String, ImageElement> images;
  Function complete;

  int total;

  ImageLoader(Function onCompletion, Map<String,String> load) {
    images = new Map<String, ImageElement>();
    total = load.length;
    complete = onCompletion;

    for (String img in load.keys) {
      // because of cors this doesn't work for arbitrary urls
      // workaround: upload to imgur and then grab the image data from there
      // add new_image.crossOrigin = "Anonymous" i think
      ImageElement new_image = new ImageElement(src: load[img]);
      new_image.onLoad.listen( (e) => loaded(img, new_image));
    }
  }
  void loaded(String img, ImageElement ele) {
    images[img] = ele;
    if (images.keys.length == total) {
      complete();
    }
  }
}

abstract class CanvasExperiment {
  CanvasElement canvas;
  CanvasRenderingContext2D context;
  ImageLoader loader;

  CanvasExperiment() {
    canvas = querySelector("#area");
    canvas.height = window.innerHeight;
    canvas.width = window.innerWidth;

    context = canvas.context2D;

    loader = new ImageLoader(this.run, {'pepsi':"Pepsi_logo_2008.svg"});
  }

  List<List<Pixel>> parse_image_data(ImageData data) {
    var pixels = new List<List<Pixel>>(data.height);

    var d = data.data;

    int stride = 4;
    for (int i = 0; i < data.height; i++) {
      pixels[i] = new List<Pixel>(data.width);
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