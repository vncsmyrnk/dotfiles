package main

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
)

const branch = "main"

type repoStandard struct{}

var _ repoStrategy = repoStandard{}

func (s repoStandard) Poll(path string) (hasUpdates bool, err error) {
	return pollGitRepo(path)
}

func (s repoStandard) Update(path string) error {
	return updateGitRepo(path)
}

func (s repoStandard) Upgrade(path string) error {
	return upgradeGitRepo(path)
}

func pollGitRepo(path string) (hasUpdates bool, err error) {
	fetchCmd := exec.Command("git", "-C", path, "fetch", "origin", "-q")
	if err = fetchCmd.Run(); err != nil {
		return
	}

	diffCmd := exec.Command("git", "-C", path, "rev-list", "HEAD...origin/"+branch, "--count")
	output, err := diffCmd.Output()
	if err != nil {
		return
	}

	countStr := strings.TrimSpace(string(output))
	count, err := strconv.Atoi(countStr)
	if err != nil {
		return
	}

	if count == 0 {
		return
	}

	return true, nil
}

func updateGitRepo(path string) error {
	resetCmd := exec.Command("git", "-C", path, "pull", "--autostash", "origin", branch)
	if err := resetCmd.Run(); err != nil {
		return fmt.Errorf("failed to reset path: %w", err)
	}
	return nil
}

func upgradeGitRepo(path string) error {
	hasFile := func(name string) bool {
		_, err := os.Stat(filepath.Join(path, name))
		return err == nil
	}

	var cmd *exec.Cmd
	if hasFile("justfile") || hasFile("Justfile") {
		cmd = exec.Command("just", "config")
	} else if hasFile("Makefile") || hasFile("makefile") {
		cmd = exec.Command("make", "install")
	} else {
		return fmt.Errorf("no installation files found")
	}

	cmd.Dir = path
	if err := cmd.Run(); err != nil {
		return fmt.Errorf("failed to upgrade repo: %w", err)
	}

	return nil
}
