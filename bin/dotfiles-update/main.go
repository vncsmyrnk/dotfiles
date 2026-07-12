package main

//go:generate go run submodules_paths.go

import (
	"fmt"
	"os"
	"sync"

	flag "github.com/spf13/pflag"
)

func main() {
	upgrade := flag.BoolP("upgrade", "u", false, "Reinstall if updates are detected")
	flag.Usage = func() {
		fmt.Fprintln(os.Stderr, "Polls and updates dotfiles git repos.")
		fmt.Fprintln(os.Stderr, "\nFlags:")
		flag.PrintDefaults()
	}
	flag.Parse()

	var wg sync.WaitGroup

	s := repoStandard{}
	for _, repo := range repos {
		wg.Go(func() {
			do(repo, s, *upgrade)
		})
	}
	wg.Wait()
}

func do(path string, s repoStrategy, upgrade bool) {
	hasUpdates, err := s.Poll(path)
	if err != nil {
		fmt.Fprintf(os.Stderr, "[%s] failed to poll repo: %v\n", path, err)
		return
	}

	if !hasUpdates {
		fmt.Printf("[%s] repo already on the latest commit\n", path)
		return
	}

	if err = s.Update(path); err != nil {
		fmt.Printf("[%s] repo already on the latest commit\n", path)
		return
	}

	if !upgrade {
		fmt.Printf("[%s] repo is now on the latest commit\n", path)
		return
	}

	if err = s.Upgrade(path); err != nil {
		fmt.Fprintf(os.Stderr, "[%s] failed to upgrade repo: %v\n", path, err)
		return
	}

	fmt.Printf("[%s] repo was reinstalled on the latest commit\n", path)
}
