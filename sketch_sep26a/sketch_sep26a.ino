#include <SPI.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64
#define OLED_RESET     -1 
#define SCREEN_ADDRESS 0x3C 

Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

// Structure for lyrics with variable delay timing for audio sync
struct LyricLine {
  const char* line1;
  const char* line2;
  int durationMs;
};

// -------------------------------------------------------------
// LYRIC DATA & TIMING
// Adjust durationMs to sync precisely with your audio playback speed
// -------------------------------------------------------------
const LyricLine songLyrics[] = {
  {"Cross my", "Heart", 1200},
  {"Hope to", "Die", 1000},
  {"To my", "Lover", 1100},
  {"I'd", "Never Lie", 1200},
  {"Said be", "True", 1000},
  {"I swear", " I'll Try", 1100},
  {"In the", "End", 1000},
  {"Its Him", "And I", 1200}
};

const int totalPhrases = sizeof(songLyrics) / sizeof(songLyrics[0]);

void setup() {
  if (!display.begin(SSD1306_SWITCHCAPVCC, SCREEN_ADDRESS)) {
    for (;;); 
  }

  // Initial graphic transition (Star icon like in the video)
  drawStarTransition();
}

void loop() {
  for (int i = 0; i < totalPhrases; i++) {
    display.clearDisplay();
    
    // Draw two vertically stacked lines centered on screen
    drawCenteredText(songLyrics[i].line1, songLyrics[i].line2);
    
    display.display();
    delay(songLyrics[i].durationMs); 
  }

  // Brief flash/transition effect before looping
  drawStarTransition();
}

// -------------------------------------------------------------
// HELPER FUNCTIONS
// -------------------------------------------------------------

// Centers two lines of text horizontally and vertically on the 128x64 display
void drawCenteredText(const char* line1, const char* line2) {
  display.setTextSize(2); // Large pixel font (matching video style)
  display.setTextColor(SSD1306_WHITE);

  int16_t x1, y1;
  uint16_t w1, h1, w2, h2;

  // Calculate pixel bounds for line 1 and line 2
  display.getTextBounds(line1, 0, 0, &x1, &y1, &w1, &h1);
  display.getTextBounds(line2, 0, 0, &x1, &y1, &w2, &h2);

  // Position line 1 centered on top
  int xPos1 = (SCREEN_WIDTH - w1) / 2;
  display.setCursor(xPos1 < 0 ? 0 : xPos1, 10);
  display.println(line1);

  // Position line 2 centered on bottom
  int xPos2 = (SCREEN_WIDTH - w2) / 2;
  display.setCursor(xPos2 < 0 ? 0 : xPos2, 36);
  display.println(line2);
}

// Draws a central filled star graphic transition
void drawStarTransition() {
  display.clearDisplay();
  
  // 5-Point Star Coordinates centered at (64, 32)
  int x = 64, y = 32;
  
  display.fillTriangle(x, y - 20, x - 6, y - 4, x + 6, y - 4, SSD1306_WHITE); // Top spike
  display.fillTriangle(x - 20, y - 6, x - 4, y - 4, x - 6, y + 6, SSD1306_WHITE); // Left spike
  display.fillTriangle(x + 20, y - 6, x + 4, y - 4, x + 6, y + 6, SSD1306_WHITE); // Right spike
  display.fillTriangle(x - 12, y + 18, x - 4, y + 2, x + 4, y + 2, SSD1306_WHITE); // Bottom Left
  display.fillTriangle(x + 12, y + 18, x - 4, y + 2, x + 4, y + 2, SSD1306_WHITE); // Bottom Right
  display.fillRect(x - 6, y - 4, 12, 10, SSD1306_WHITE);                          // Center core
  
  display.display();
  delay(800);
  display.clearDisplay();
  display.display();
  delay(200);
}