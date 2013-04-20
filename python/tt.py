from pyglet import app, window, text, clock, event
from pyglet.window import key


class Gui():
    def __init__(self, layout=None):
        self.show = False
        self.layout = layout

    def fps(self):
        return 'FPS: %i' % clock.get_fps()

    def toogle(self, option):
        if hasattr(self.__class__, option):
            self.option = not self.option

    @classmethod
    def _get(cls, option):
        return getattr(cls, option)
        #print self.show

    def _set(self, option, bool):
        if hasattr(self.__class__, option):
            self.option = bool

    def update(self):
        self.layout.begin_update()
        self.layout.text = self.info.fps()
        self.layout.end_update()

    def draw(self):
        if self.show:
            self.update()
            self.layout.draw()


win = window.Window(width=800,
                    height=600,
                    resizable=True,
                    caption="Test")

event_loop = app.EventLoop()
gui = Gui(layout=text.Label(font_name='arial',
                            font_size=20,
                            color=(255, 255, 255, 255),
                            anchor_x='left',
                            anchor_y='center',
                            x=1, y=15))

clock.set_fps_limit(60)


@win.event
def on_draw():
    win.clear()
    gui.draw()
    asd(gui.fps())
    asd(gui._get('show'))
    asd('draw')


@win.event
def on_key_press(symbol, modifiers):
    if symbol == key.SPACE:
        asd('space')
        gui.toogle('show')
#win.push_handlers(event.WindowEventLogger())


@event_loop.event
def on_window_close(win):
    app.exit()
    asd('exit')


def asd(txt):
    print txt


def main():
    event_loop.run()

if __name__ == "__main__":
    main()
