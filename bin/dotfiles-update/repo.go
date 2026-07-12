package main

type repoStrategy interface {
	Poll(path string) (hasUpdates bool, err error)
	Update(path string) error
	Upgrade(path string) error
}
