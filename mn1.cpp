#include<iostream>
#include <string>
#define SIZE 256
using namespace std;
//horspool algorithm in cpp
string text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit.";
int table[SIZE];

int preprocess(string P)
{
    for(int i = 0 ; i < SIZE ; i++)
    {
        table[i]=P.length();
    }
    for(int i = 0 ; i < P.length()-1;i++)
    {
        table[P[i]] = P.length()-1-i;
    }

}
int horspool(string P)
{
    int i;
    preprocess(P);
    int skip = 0;
    while (text.length()-skip >= P.length())
    {
        i = P.length() - 1;
        while(text[skip+i] == P[i])
        {
            if( i == 0)
                return skip;
            i = i - 1;
        }
        skip = skip + table[text[skip+P.length()-1]];
    }
    return -1;

}
int main()
{
    int check;
    string pattern;
    cout<<"Text :"<<endl;
    cout<<text<<endl;
    cout<<"Pattern:";
    getline(cin,pattern);
    check = horspool(pattern);
    if(check == -1){
        cout<<"not-found"<<endl;
    }
    else{
        cout<<"found at "<<check<<endl;
    }

    return 0;
}

