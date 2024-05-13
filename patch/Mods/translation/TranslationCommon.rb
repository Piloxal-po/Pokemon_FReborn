DIR_I18N = "patch/Mods/translation/i18n/"

EXTENSIONS = [
    ".png", ".PNG", ".ogg", ".OGG", ".ttf", ".TTF"
]

def getDiri18n
    return DIR_I18N + LANGUAGES[$Settings.language][1] + "/"
end

def getPathWithTranslation(path)
    if path.instance_of?(String)  && (File.exist?(getDiri18n + path) || EXTENSIONS.any? { |ex| File.exist?(getDiri18n + path + ex)})
        return getDiri18n + path
    end
    return path
end