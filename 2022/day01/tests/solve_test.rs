#[cfg(test)]
mod tests {
    #[test]
    fn part_a() {
        let (a, _) = day01::solve();
        assert_eq!(a, 71124);
    }

    #[test]
    fn part_b() {
        let (_, b) = day01::solve();
        assert_eq!(b, 204639);
    }
}
