def cache
  if ENV["HOMEBREW_CACHE"]
    Pathname.new(ENV["HOMEBREW_CACHE"]).expand_path
  else
    # we do this for historic reasons, however the cache *should* be the same
    # directory whichever user is used and whatever instance of brew is executed
    home_cache = Pathname.new(if OS.mac? then "~/Library/Caches/Homebrew"
        else "~/.cache/Homebrew" end).expand_path
    if home_cache.directory? && home_cache.writable_real? \
        or not Pathname.new("/Library/Caches").writable_real?
      home_cache
    else
      Pathname.new("/Library/Caches/Homebrew").extend Module.new {
        def mkpath
          unless exist?
            super
            chmod 0775
          end
        end
      }
    end
  end
end

HOMEBREW_CACHE = cache
undef cache

# Where brews installed via URL are cached
HOMEBREW_CACHE_FORMULA = HOMEBREW_CACHE+"Formula"

HOMEBREW_BREW_FILE = ENV["HOMEBREW_BREW_FILE"]
unless HOMEBREW_BREW_FILE
  odie "HOMEBREW_BREW_FILE was not exported! Please call bin/brew directly!"
end

# Where we link under
HOMEBREW_PREFIX = Pathname.new(ENV["HOMEBREW_PREFIX"])

# Where .git is found
HOMEBREW_REPOSITORY = Pathname.new(ENV["HOMEBREW_REPOSITORY"])

HOMEBREW_LIBRARY = Pathname.new(ENV["HOMEBREW_LIBRARY"])
HOMEBREW_CONTRIB = HOMEBREW_REPOSITORY/"Library/Contributions"

# Where we store built products
HOMEBREW_CELLAR = Pathname.new(ENV["HOMEBREW_CELLAR"])

HOMEBREW_LOGS = Pathname.new(ENV["HOMEBREW_LOGS"] ||
  (OS.mac? ? "~/Library/Logs/Homebrew/" : "~/.cache/Homebrew/Logs")).expand_path

HOMEBREW_TEMP = Pathname.new(ENV.fetch("HOMEBREW_TEMP", "/tmp"))

unless defined? HOMEBREW_LIBRARY_PATH
  HOMEBREW_LIBRARY_PATH = Pathname.new(__FILE__).realpath.parent.join("Homebrew")
end

HOMEBREW_LOAD_PATH = HOMEBREW_LIBRARY_PATH
