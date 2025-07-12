import React, { useState } from 'react';
import { Upload, Download, FileText, AlertCircle, CheckCircle, X } from 'lucide-react';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';

interface BulkUploadItem {
  title: string;
  description: string;
  category: string;
  type: string;
  size: string;
  condition: string;
  tags: string;
  image_url: string;
  user_email: string;
}

export default function BulkUpload() {
  const { user } = useAuth();
  const [file, setFile] = useState<File | null>(null);
  const [uploading, setUploading] = useState(false);
  const [results, setResults] = useState<{ success: number; errors: string[] } | null>(null);
  const [showModal, setShowModal] = useState(false);

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const selectedFile = e.target.files?.[0];
    if (selectedFile && selectedFile.type === 'text/csv') {
      setFile(selectedFile);
      setResults(null);
    } else {
      alert('Please select a valid CSV file');
    }
  };

  const downloadTemplate = () => {
    const template = `title,description,category,type,size,condition,tags,image_url,user_email
Vintage Denim Jacket,Classic blue denim jacket in excellent condition,Outerwear,Casual,M,Like New,"vintage,denim,jacket",https://images.pexels.com/photos/1124460/pexels-photo-1124460.jpeg,user@example.com
Summer Floral Dress,Beautiful floral print dress perfect for summer,Dresses,Casual,S,Good,"floral,summer,dress",https://images.pexels.com/photos/1536619/pexels-photo-1536619.jpeg,user@example.com
Black Leather Boots,Stylish black leather ankle boots,Footwear,Formal,8,Excellent,"leather,boots,black",https://images.pexels.com/photos/1464625/pexels-photo-1464625.jpeg,user@example.com`;

    const blob = new Blob([template], { type: 'text/csv' });
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'bulk_upload_template.csv';
    a.click();
    window.URL.revokeObjectURL(url);
  };

  const parseCSV = (csvText: string): BulkUploadItem[] => {
    const lines = csvText.split('\n');
    const headers = lines[0].split(',').map(h => h.trim());
    const items: BulkUploadItem[] = [];

    for (let i = 1; i < lines.length; i++) {
      const line = lines[i].trim();
      if (!line) continue;

      const values = line.split(',').map(v => v.trim().replace(/^"|"$/g, ''));
      const item: any = {};

      headers.forEach((header, index) => {
        item[header] = values[index] || '';
      });

      items.push(item as BulkUploadItem);
    }

    return items;
  };

  const handleUpload = async () => {
    if (!file || !user) return;

    setUploading(true);
    const errors: string[] = [];
    let successCount = 0;

    try {
      const csvText = await file.text();
      const items = parseCSV(csvText);

      for (let i = 0; i < items.length; i++) {
        const item = items[i];
        
        try {
          // Find user by email
          const { data: userData, error: userError } = await supabase
            .from('user_rewear')
            .select('id')
            .eq('email', item.user_email)
            .single();

          if (userError || !userData) {
            errors.push(`Row ${i + 2}: User not found for email ${item.user_email}`);
            continue;
          }

          // Insert item
          const { error: itemError } = await supabase
            .from('items')
            .insert({
              user_id: userData.id,
              title: item.title,
              description: item.description,
              category: item.category,
              type: item.type,
              size: item.size,
              condition: item.condition,
              tags: item.tags ? item.tags.split(',').map(t => t.trim()) : [],
              is_available: true
            });

          if (itemError) {
            errors.push(`Row ${i + 2}: ${itemError.message}`);
            continue;
          }

          // If we have an image URL, we could insert it into item_images table
          // For now, we'll skip image insertion to keep it simple

          successCount++;

          // Log admin action
          await supabase
            .from('admin_logs_rewear')
            .insert({
              admin_id: user.id,
              action_type: 'bulk_upload_item',
              target_id: userData.id,
              details: `Bulk uploaded item: ${item.title}`
            });

        } catch (error) {
          errors.push(`Row ${i + 2}: ${error instanceof Error ? error.message : 'Unknown error'}`);
        }
      }

      setResults({ success: successCount, errors });
    } catch (error) {
      errors.push(`File parsing error: ${error instanceof Error ? error.message : 'Unknown error'}`);
      setResults({ success: 0, errors });
    }

    setUploading(false);
  };

  return (
    <>
      <button
        onClick={() => setShowModal(true)}
        className="inline-flex items-center gap-2 px-4 py-2 bg-emerald-600 text-white rounded-lg hover:bg-emerald-700 transition-colors"
      >
        <Upload size={20} />
        Bulk Upload Items
      </button>

      {showModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-xl p-6 w-full max-w-2xl max-h-[90vh] overflow-y-auto">
            <div className="flex items-center justify-between mb-6">
              <h3 className="text-xl font-semibold text-stone-800">Bulk Upload Items</h3>
              <button
                onClick={() => setShowModal(false)}
                className="p-2 text-stone-400 hover:text-stone-600 transition-colors"
              >
                <X size={20} />
              </button>
            </div>

            <div className="space-y-6">
              {/* Instructions */}
              <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
                <h4 className="font-medium text-blue-800 mb-2">Instructions:</h4>
                <ol className="text-sm text-blue-700 space-y-1 list-decimal list-inside">
                  <li>Download the CSV template below</li>
                  <li>Fill in your item data following the format</li>
                  <li>Upload the completed CSV file</li>
                  <li>Review the results and fix any errors</li>
                </ol>
              </div>

              {/* Template Download */}
              <div className="border border-stone-200 rounded-lg p-4">
                <div className="flex items-center justify-between">
                  <div>
                    <h4 className="font-medium text-stone-800">CSV Template</h4>
                    <p className="text-sm text-stone-600">Download the template with sample data</p>
                  </div>
                  <button
                    onClick={downloadTemplate}
                    className="inline-flex items-center gap-2 px-3 py-2 text-emerald-600 border border-emerald-600 rounded-lg hover:bg-emerald-50 transition-colors"
                  >
                    <Download size={16} />
                    Download Template
                  </button>
                </div>
              </div>

              {/* File Upload */}
              <div className="border border-stone-200 rounded-lg p-4">
                <h4 className="font-medium text-stone-800 mb-3">Upload CSV File</h4>
                <div className="border-2 border-dashed border-stone-300 rounded-lg p-6 text-center">
                  <FileText className="w-12 h-12 text-stone-400 mx-auto mb-3" />
                  <input
                    type="file"
                    accept=".csv"
                    onChange={handleFileChange}
                    className="hidden"
                    id="csv-upload"
                  />
                  <label
                    htmlFor="csv-upload"
                    className="cursor-pointer text-emerald-600 hover:text-emerald-700 font-medium"
                  >
                    Choose CSV file
                  </label>
                  <p className="text-sm text-stone-500 mt-1">or drag and drop</p>
                  {file && (
                    <p className="text-sm text-stone-700 mt-2 font-medium">{file.name}</p>
                  )}
                </div>
              </div>

              {/* Results */}
              {results && (
                <div className="border border-stone-200 rounded-lg p-4">
                  <h4 className="font-medium text-stone-800 mb-3">Upload Results</h4>
                  
                  <div className="flex items-center gap-2 mb-3">
                    <CheckCircle className="w-5 h-5 text-emerald-600" />
                    <span className="text-emerald-700 font-medium">
                      {results.success} items uploaded successfully
                    </span>
                  </div>

                  {results.errors.length > 0 && (
                    <div className="space-y-2">
                      <div className="flex items-center gap-2">
                        <AlertCircle className="w-5 h-5 text-red-600" />
                        <span className="text-red-700 font-medium">
                          {results.errors.length} errors occurred:
                        </span>
                      </div>
                      <div className="bg-red-50 border border-red-200 rounded-lg p-3 max-h-32 overflow-y-auto">
                        {results.errors.map((error, index) => (
                          <p key={index} className="text-sm text-red-700">{error}</p>
                        ))}
                      </div>
                    </div>
                  )}
                </div>
              )}

              {/* Actions */}
              <div className="flex gap-3">
                <button
                  onClick={() => setShowModal(false)}
                  className="flex-1 px-4 py-2 text-stone-600 bg-stone-100 rounded-lg hover:bg-stone-200 transition-colors"
                >
                  Close
                </button>
                <button
                  onClick={handleUpload}
                  disabled={!file || uploading}
                  className="flex-1 px-4 py-2 text-white bg-emerald-600 rounded-lg hover:bg-emerald-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  {uploading ? 'Uploading...' : 'Upload Items'}
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </>
  );
}