class Solution:
    def intersect(self, nums1: List[int], nums2: List[int]) -> List[int]:
        sol = [] #empty array to add numbers to
        print(nums1)
        for x in nums1:
            sol.append(nums2.remove(x))
        print(sol)
        return sol