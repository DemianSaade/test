from pyglet import app, window, text, clock
from pyglet.window import key, event

class Gui():
    def __init__(self):
        self.show = False

    
    def info(self, option, layer=None):
        self.layout = text.Label('FPS: %f' % clock.get_fps(),
                    font_name='arial',
                    font_size=10,
                    color=(255,255,255,255),
                    anchor_x='left', anchor_y='center',
                    x=1, y=10)

        if option == 't':
            self.show = not self.show
        if option == 'c':
            return bool(self.show)
        if option == 'd':
            self.show = True
            self.layout.draw()

    def draw(self):
        if self.show: self.info('d')

win = window.Window(width=800, height=600)
#win2 = window.Window(width=800, height=600)
event_loop = app.EventLoop()
gui = Gui()

clock.set_fps_limit(60)

@win.event
def on_draw():
    win.clear()
    gui.draw()
    asd(str(gui.info('c')))
    asd('draw')

@win.event
def on_key_press(symbol, modifiers):
    if symbol == key.SPACE:
        asd('space')
        gui.info('t')
#win.push_handlers(event.WindowEventLogger())

@event_loop.event
def on_window_close(window):
    app.exit()
    asd('exit')

def asd(text):
    print text

def main():
    event_loop.run()

if __name__ == "__main__":
    main()