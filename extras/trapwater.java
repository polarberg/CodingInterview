class Solution{
    public int trap(int[] height) {

        int n = height.length;

        if(n<=1) return 0;

        int[] waterSE = new int[n]; //Start-End
        int[] waterES = new int[n]; //End-Start

        int maxHeight = height[0];
        // First block can't hold any water
        waterSE[0] = 0; 

        // From Start to end 
        for(int i=1; i<n; i++){
            if(maxHeight < height[i]) 
                // update the maxHeight and we skip the water (i.e this block can't store any water because it is equal to that of maxHeight)
                maxHeight = height[i];
            else
                waterSE[i] = maxHeight - height[i];        
        }

        int total =0; 

    }
}