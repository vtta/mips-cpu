
/* 
void inline swap(int *a, int *b){
    int t=*a;
    *a=*b;
    *b=*a;
}

void bubble_sort(int *arr, int sz) {
    for (int i = 0; i < sz; ++i) {
        for (int j = i+1; j < sz; ++j) {
            if (arr[j-1]<arr[j]){
                swap(arr+j-1, arr+j);
            }
        }
    }
}

int main(int argc, char** argv) {
    int arr[5] = {
        0x10001008,0x10001002,0x80001001,0x10001005,0x80001000
    };
    int sz = 5;
    bubble_sort(arr, sz);
    return 0;
}
*/

void bubble_sort() {
    const int sz = 5;
    int i, j, t, arr[5] = {
        // 0x10001008,0x10001002,0x80001001,0x10001005,0x80001000
        // 268439560, 268439554, -2147479551, 268439557, -2147479552
        0x10001008,0x1001002,-0x7FFFEFFF,0x10001005,-0x7FFFF000
    };
    for (i = 0; i < sz; ++i) {
        for (j = 1; j < sz-i; ++j) {
            if (arr[j-1]>arr[j]){
                t=arr[j-1];
                arr[j-1]=arr[j];
                arr[j]=t;
            }
        }
    }
}
