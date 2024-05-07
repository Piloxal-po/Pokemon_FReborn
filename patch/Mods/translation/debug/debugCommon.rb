DIR_DEBUG_I18N = "patch/Mods/translation/debug/i18n/"

DIR_I18N = "patch/Mods/translation/i18n/"

MOVES_FILE = "moves"

ABILITIES_FILE = "abil"

MESSAGE_FILE = "messages"

DEBUG_COMMANDS = []


def getDebugCommand
    if DEBUG_COMMANDS.empty?
        DEBUG_COMMANDS.concat [
            ["[MOD] generate translation file", self.method(:generateDebugTranslationModFile)],
            ["[MOD] compile move translation file", self.method(:debugCompileMoves)],
            ["[MOD] compile ability translation file", self.method(:debugCompileAbilities)],
            ["[MOD] compile message translation file", self.method(:debugCompileMessages)],
            ["[MOD] compile all translation file", self.method(:debugCompileAll)]
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