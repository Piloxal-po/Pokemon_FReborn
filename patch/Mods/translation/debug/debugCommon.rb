DEBUG_TRANSLATION_MOD_ENABLE = true

DIR_DEBUG_I18N = "patch/Mods/translation/debug/i18n/"

MOVES_FILE = "moves"

ABILITIES_FILE = "abil"

MESSAGE_FILE = "messages"

ITEM_FILE = "items"

MONS_FILE = "mons"

NATURE_FILE = "natures"

MAP_INFO_FILE = "mapinfo"

TRAINER_FILE = "trainers"

DEBUG_COMMANDS = []


def getDebugCommand
    if DEBUG_COMMANDS.empty?
        DEBUG_COMMANDS.concat [
            ["[DTF] extract translation file", self.method(:generateDebugTranslationModFile)],
            ["[DTF] extract convert translation file", self.method(:generateTrainersDebugConvertTranslationFile)],
            ["[DTF] compile move translation file", self.method(:debugCompileMoves)],
            ["[DTF] compile ability translation file", self.method(:debugCompileAbilities)],
            ["[DTF] compile message translation file", self.method(:debugCompileMessages)],
            ["[DTF] compile items translation file", self.method(:debugCompileItems)],
            ["[DTF] compile mons translation file", self.method(:debugCompileMons)],
            ["[DTF] compile nature translation file", self.method(:debugCompileNatures)],
            ["[DTF] compile map info translation file", self.method(:debugCompileMapInfos)],
            ["[DTF] compile trainer translation file", self.method(:debugCompileTrainers)],
            ["[DTF] compile all translation file", self.method(:debugCompileAll)]
        ]
    end
    return DEBUG_COMMANDS
end

def choiceLanguage
    commands=[]
    for lang in LANGUAGES
      commands.push(lang[0])
    end
    return LANGUAGES[Kernel.pbShowCommands(nil,commands)][1]
end

def debugMkdir(dir)
    gem 'fileutils'
    FileUtils.mkdir_p(dir)
end