# -*- coding: utf-8 -*-
"""
    Jalanb Colorscheme
    ~~~~~~~~~~~~~~~~~~

    Converted by Vim Colorscheme Converter
"""
from pygments.style import Style
from pygments.token import Token, Generic, String, Name, Operator, Comment, Keyword, Number

class JalanbStyle(Style):

    background_color = '#000000'
    styles = {
        Token:              '#ffffff',

        Keyword:            '#d70000 bold',
        Keyword.Type:       '#5f0000 bold',

        Generic.Error:      'bg:#ff0000',

        Comment:                   "#626262", # class: 'c'
        Comment.Multiline:         "",        # class: 'cm'
        Comment.Preproc:           "",        # class: 'cp'
        Comment.Single:            "",        # class: 'c1'
        Comment.Special:           "",        # class: 'cs'

        String:             '#0000ff',
        String.Doc:         '#626262',        # class: 'sd' - like a comment
        String.Heredoc:     '#626262',        # class: 'sh'


        Name:                      "#88f", # class: 'na' - to be revised
        Name.Attribute:            "#00ff00", # class: 'na' - to be revised
        Name.Builtin:              "",        # class: 'nb'
        Name.Builtin.Pseudo:       "",        # class: 'bp'
        Name.Constant:             "#00ff00", # class: 'no' - to be revised
        Name.Entity:               "#00ff00 bold",        # class: 'ni'
        Name.Exception:            "#00ff00 bold", # class: 'ne'
        Name.Class:                "#044", # class: 'nc' - to be revised
        Name.Decorator:            "#0f0", # class: 'nd' - to be revised
        Name.Function:             "#0f0", # class: 'nf'
        Name.Method:               "#0f0", # class: 'nc' - to be revised
        Name.Property:             "",        # class: 'py'
        Name.Label:                "",        # class: 'nl'
        Name.Namespace:            "",        # class: 'nn' - to be revised
        Name.Other:                "#00ff00", # class: 'nx'
        Name.Variable:             "#00ff00",        # class: 'nv' - to be revised
        Name.Variable.Class:       "",        # class: 'vc' - to be revised
        Name.Variable.Global:      "",        # class: 'vg' - to be revised
        Name.Variable.Instance:    "",        # class: 'vi' - to be revised
        Name.Tag:           '#d70000 bold',
    }
