import 'dart:html';

CanvasElement canvas;
CanvasRenderingContext2D context;

void main() {
  canvas = querySelector("#area");
  context = canvas.context2D;

  run();
}

void run() {
  window.requestAnimationFrame(render);
}

void render(num time) {
  context.clearRect(0,0,canvas.height,canvas.width);

  ImageData pixels = context.getImageData(0,0,canvas.height,canvas.width);

  for (int i = 0; i < pixels.data.length; i++) {
    pixels.data[i] = 20;
  }

  context.putImageData(pixels, 0, 0);

  window.requestAnimationFrame(render);
}
