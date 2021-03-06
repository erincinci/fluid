"""
Browse your local movies with IMDB data and stream them to a Chromecast.
"""
from flask import Flask, render_template
from flask_bower import Bower
from app.routes import root
import logging
import os


def init_app():
    """Returns an instance of the application."""
    app = Flask(__name__)
    app.config.update({
        'CHROMECAST_IP': os.environ['CHROMECAST_IP'],
        'MEDIA_PATH': os.environ['MEDIA_PATH'],
        'SECRET_KEY': os.environ['SECRET_KEY'],
        'LOG_PATH': os.environ.get('LOG_PATH', 'fluid.log'),
    })
    init_blueprints(app)
    init_extensions(app)
    init_logging(app)

    @app.route('/')
    def index():
        """Returns the page markup."""
        return render_template('index.html')

    return app


def init_blueprints(app):
    """Registers blueprints with the application."""
    app.register_blueprint(root)


def init_extensions(app):
    """Registers extensions with the application."""
    Bower(app)


def init_logging(app):
    """Setup logging for the application."""
    logger = logging.getLogger()

    # Describe format of logs
    log_format = str(
        '%(asctime)s:%(levelname)s:%(module)s.py:%(lineno)d - %(message)s'
    )

    # Setup the StreamHandler to log to stderr
    logging.basicConfig(level=logging.DEBUG, format=log_format)

    if app.debug:  # Logging to stderr is sufficient when debugging
        return

    # Setup a FileHandler to log to a configurable path
    file_handler = logging.FileHandler(app.config['LOG_PATH'])
    file_handler.setLevel(logging.DEBUG)
    file_handler.setFormatter(logging.Formatter(log_format))
    logger.addHandler(file_handler)
