local configure = require("@monorepo/configure")
local cwdrequire = require("@lib/utils/requireCwd")
local process = require("@lute/process")

local function useRepository(maybeRepoPath: string?): configure.RepositoryConfig
	local repoPath = maybeRepoPath or "__config__"
	local repoRequired, repoConfigOrErrror = pcall(cwdrequire, repoPath)

	if not repoRequired then
		print(`Failed to require repository config from {repoPath}:`)
		print(repoConfigOrErrror)
		return process.exit(1)
	end

	local repoResult = configure.RepositoryConfig:match(repoConfigOrErrror)
	if not repoResult.ok then
		print(`Invalid repository config at {repoPath}:`)
		print(repoResult:format())
		return process.exit(1)
	end

	return repoConfigOrErrror
end

return useRepository
