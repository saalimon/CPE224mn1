#include<iostream>
#include <string>
#define SIZE 256
using namespace std;

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
    int j;
    int found = 0;
    preprocess(P);
    int skip = 0;
    while (text.length()-skip >= P.length())
    {
        i = P.length() - 1;
        while(text[skip+i] == P[i])
        {
            if( i == 0){
                found = found+1;
                break;
            }
            i = i - 1;
        }
        skip = skip + table[text[skip+P.length()-1]];
    }
    return found;

}

int main()
{
    int found;
    string pattern;
    cout<<"Text :";
    getline(cin,text);
    //cout<<text<<endl;
    cout<<"Pattern:";
    getline(cin,pattern);
    found = horspool(pattern);
    if(found == 0){
        cout<<"not-found"<<endl;
    }
    else{
        cout<<"found "<<found<<" matches"<<endl;
    }

    return 0;
}

