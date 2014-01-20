# -*- coding: utf-8 -*-
"""
    Alan-Colour Colorscheme
    ~~~~~~~~~~~~~~~~~~~~~~~

    Converted by Vim Colorscheme Converter
"""
from pygments.style import Style
from pygments.token import Token, Comment, Name, Keyword, Generic, Number, Operator, String

class Alan_ColourStyle(Style):

    background_color = '#000000'
    styles = {
        Token:              '#ffffff bg:#000000',
        Name.Constant:      'noinherit #0066FF',
        Name.Entity:        '#ff4444 bold',
        Name.Tag:           '#ff0000 bold',
        Keyword:            '#ff0000 bold',
        String:             '#8a2be2',
        Comment:            '#808080',
        Generic.Error:      'bg:#ff0000',
        Name.Exception:     '#5f0000 bold',
        Name.Variable:      '#44ff44',
        Keyword.Type:       '#ff4444 bold',
        Comment.Preproc:    '#ff4444 bold',
    }
